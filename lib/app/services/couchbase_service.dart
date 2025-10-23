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
        final activity = change.status.activity;
        final error = change.status.error;
        final progress = change.status.progress;

        if (error != null) {
          print('❌ ERRO DE REPLICAÇÃO: $error');
        }

        print(
            '🔄 STATUS DA REPLICAÇÃO: $activity - Progresso: ${progress.completed} documentos processados');

        if (activity == ReplicatorActivityLevel.idle) {
          print(
              '✅ SINCRONIZAÇÃO CONCLUÍDA - ${progress.completed} documentos sincronizados com sucesso');
          onSynced();
        } else if (activity == ReplicatorActivityLevel.connecting) {
          print('🔗 CONECTANDO AO SERVIDOR...');
        } else if (activity == ReplicatorActivityLevel.busy) {
          print(
              '⚡ SINCRONIZANDO DADOS... (${progress.completed} documentos processados até agora)');
        } else if (activity == ReplicatorActivityLevel.stopped) {
          print('⏹️ REPLICAÇÃO PARADA');
        }
      });
      await replicator?.start();
    }
  }

  void networkStatusListen() {
    networkConnection = Connectivity().onConnectivityChanged.listen((events) {
      if (events.contains(ConnectivityResult.none)) {
        print('🔴 SEM CONEXÃO COM A INTERNET - Parando replicação');
        replicator?.stop();
      } else {
        print('🟢 CONECTADO COM A INTERNET - Iniciando replicação');
        print('🔄 Sincronizando documentos pendentes com o servidor...');
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
      print(
          '📝 DOCUMENTO CRIADO LOCALMENTE: ${document.id} - Dados: ${data.toString()}');
      print(
          '🔄 Este documento será sincronizado quando houver conexão com a internet');
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
    print('Documentos buscados localmente: ${data?.length ?? 0}');
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
        print(
            '✏️ DOCUMENTO EDITADO LOCALMENTE: $id - Novos dados: ${data.toString()}');
        print(
            '🔄 Esta edição será sincronizada quando houver conexão com a internet');
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
        print('🗑️ DOCUMENTO DELETADO LOCALMENTE: $id');
        print(
            '🔄 Esta exclusão será sincronizada quando houver conexão com a internet');
        return result;
      }
    }
    return false;
  }
}
