import 'dart:async';

import 'package:cbl/cbl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../utils/couchbase_constants.dart';

class CouchbaseService {
  AsyncDatabase? database;
  AsyncReplicator? replicator;
  StreamSubscription<List<ConnectivityResult>>? networkConnection;

  Future<void> init() async {
    database ??= await Database.openAsync('database');
  }

  Future<void> startReplication({required Function() onSynced}) async {
    final collection = await database?.createCollection(
      CouchbaseContants.collection,
      CouchbaseContants.scope,
    );
    if (collection != null) {
      final replicatorConfig = ReplicatorConfiguration(
        target: UrlEndpoint(Uri.parse(CouchbaseContants.publicConnectionUrl)),
        authenticator: BasicAuthenticator(
          username: CouchbaseContants.userName,
          password: CouchbaseContants.password,
        ),
        continuous: true,
        replicatorType: ReplicatorType.pushAndPull,
        enableAutoPurge: true,
      );
      replicatorConfig.addCollection(
        collection,
        CollectionConfiguration(
          channels: [CouchbaseContants.channel],
          conflictResolver: ConflictResolver.from((conflict) {
            return conflict.remoteDocument ?? conflict.localDocument;
          }),
        ),
      );
      replicator = await Replicator.createAsync(replicatorConfig);

      replicator?.addChangeListener((change) {
        final status = change.status;

        if (status.activity == ReplicatorActivityLevel.idle) {
          onSynced();
        }
      });

      await replicator?.start();
    }
  }

  void networkStatusListen() {
    networkConnection = Connectivity().onConnectivityChanged.listen((events) {
      if (events.contains(ConnectivityResult.none)) {
        replicator?.stop();
      } else {
        replicator?.start();
      }
    });
  }

  Future<bool> add({
    required Map<String, dynamic> data,
    required String collectionName,
  }) async {
    final collection = await database?.createCollection(
      collectionName,
      CouchbaseContants.scope,
    );
    if (collection != null) {
      final document = MutableDocument(data);
      final result = await collection.saveDocument(
        document,
        ConcurrencyControl.lastWriteWins,
      );
      return result;
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> fetch({
    required String collectionName,
    String? filter,
  }) async {
    await init();
    await database?.createCollection(collectionName, CouchbaseContants.scope);

    final query = await database?.createQuery(
      'SELECT META().id, * FROM ${CouchbaseContants.scope}.$collectionName ${filter != null ? 'WHERE $filter' : ''}',
    );
    final result = await query?.execute();
    final results = await result?.allResults();
    final data = results
        ?.map(
          (e) => {
            'id': e.string('id'),
            ...(e.toPlainMap()[collectionName] as Map<String, dynamic>),
          },
        )
        .toList();

    return data ?? [];
  }

  Future<bool> edit({
    required String collectionName,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    final collection = await database?.createCollection(
      collectionName,
      CouchbaseContants.scope,
    );
    if (collection != null) {
      final doc = await collection.document(id);
      if (doc != null) {
        final mutableDoc = doc.toMutable();
        data.forEach((key, value) {
          mutableDoc.setValue(value, key: key);
        });

        final result = await collection.saveDocument(
          mutableDoc,
          ConcurrencyControl.lastWriteWins,
        );

        return result;
      }
    }
    return false;
  }

  Future<bool> delete({
    required String collectionName,
    required String id,
  }) async {
    final collection = await database?.createCollection(
      collectionName,
      CouchbaseContants.scope,
    );
    if (collection != null) {
      final doc = await collection.document(id);
      if (doc != null) {
        final result = await collection.deleteDocument(
          doc,
          ConcurrencyControl.lastWriteWins,
        );

        return result;
      }
    }
    return false;
  }
}
