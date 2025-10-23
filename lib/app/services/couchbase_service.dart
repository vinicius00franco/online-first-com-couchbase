import 'dart:async';

import 'package:cbl/cbl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../utils/couchbase_constants.dart';
import '../utils/logger.dart' as app_logger;

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
      // Adicionar logs para início da replicação
      app_logger.Logger.instance.info(
          'Iniciando replicação com Sync Gateway em ${CouchbaseContants.publicConnectionUrl}');

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

      // Adicionar listener para logs de sincronização
      replicator?.addChangeListener((change) {
        final status = change.status;
        final progress = status.progress;

        // Log de progresso da replicação
        app_logger.Logger.instance.info(
            'Replicação em andamento - Completado: ${progress.completed}');

        // Log de erros de replicação
        if (status.error != null) {
          app_logger.Logger.instance
              .error('Erro na replicação: ${status.error}');
        }

        // Log quando replicação estiver ociosa (sem atividade)
        if (status.activity == ReplicatorActivityLevel.idle) {
          app_logger.Logger.instance
              .info('Replicação ociosa - aguardando mudanças');
        }

        // Log quando replicação estiver parada
        if (status.activity == ReplicatorActivityLevel.stopped) {
          app_logger.Logger.instance.info('Replicação parada');
        }

        // Chamar callback quando sincronizado
        if (status.activity == ReplicatorActivityLevel.idle) {
          app_logger.Logger.instance
              .info('Sincronização completa - documentos sincronizados');
          onSynced();
        }
      });

      await replicator?.start();
      app_logger.Logger.instance.info('Replicação iniciada com sucesso');
    }
  }

  void networkStatusListen() {
    networkConnection = Connectivity().onConnectivityChanged.listen((events) {
      if (events.contains(ConnectivityResult.none)) {
        app_logger.Logger.instance
            .info('SEM CONEXÃO COM A INTERNET - Parando replicação');
        app_logger.Logger.instance.info(
            'Modo offline ativado - operações locais continuam funcionando');
        replicator?.stop();
      } else {
        app_logger.Logger.instance
            .info('CONECTADO COM A INTERNET - Iniciando replicação');
        app_logger.Logger.instance
            .info('Sincronizando documentos pendentes com o servidor...');
        app_logger.Logger.instance
            .info('Verificando conflitos e aplicando mudanças remotas...');
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
      app_logger.Logger.instance.info(
          'CRIANDO NOVO DOCUMENTO - Coleção: $collectionName, ID gerado: ${document.id}');
      app_logger.Logger.instance.info('Dados do documento: ${data.toString()}');

      final result = await collection.saveDocument(
        document,
        ConcurrencyControl.lastWriteWins,
      );

      if (result) {
        app_logger.Logger.instance
            .info('DOCUMENTO CRIADO COM SUCESSO LOCALMENTE: ${document.id}');
        app_logger.Logger.instance.info(
            'Este documento será sincronizado quando houver conexão com a internet');
      } else {
        app_logger.Logger.instance
            .error('FALHA AO CRIAR DOCUMENTO: ${document.id}');
      }

      return result;
    }
    app_logger.Logger.instance.error('FALHA AO CRIAR COLEÇÃO: $collectionName');
    return false;
  }

  Future<List<Map<String, dynamic>>> fetch({
    required String collectionName,
    String? filter,
  }) async {
    await init();
    await database?.createCollection(collectionName, CouchbaseContants.scope);

    app_logger.Logger.instance.info(
        'BUSCANDO DOCUMENTOS - Coleção: $collectionName${filter != null ? ', Filtro: $filter' : ''}');

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

    app_logger.Logger.instance
        .info('Documentos encontrados localmente: ${data?.length ?? 0}');
    if (data != null && data.isNotEmpty) {
      app_logger.Logger.instance.info(
          'IDs dos documentos: ${data.map((doc) => doc['id']).join(', ')}');
    }

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
        app_logger.Logger.instance
            .info('EDITANDO DOCUMENTO - Coleção: $collectionName, ID: $id');
        app_logger.Logger.instance
            .info('Dados atuais: ${doc.toPlainMap().toString()}');
        app_logger.Logger.instance.info('Novos dados: ${data.toString()}');

        final mutableDoc = doc.toMutable();
        data.forEach((key, value) {
          mutableDoc.setValue(value, key: key);
        });

        final result = await collection.saveDocument(
          mutableDoc,
          ConcurrencyControl.lastWriteWins,
        );

        if (result) {
          app_logger.Logger.instance
              .info('DOCUMENTO EDITADO COM SUCESSO LOCALMENTE: $id');
          app_logger.Logger.instance.info(
              'Esta edição será sincronizada quando houver conexão com a internet');
        } else {
          app_logger.Logger.instance.error('FALHA AO EDITAR DOCUMENTO: $id');
        }

        return result;
      } else {
        app_logger.Logger.instance.error(
            'DOCUMENTO NÃO ENCONTRADO PARA EDIÇÃO: $id na coleção $collectionName');
      }
    } else {
      app_logger.Logger.instance
          .error('FALHA AO CRIAR COLEÇÃO PARA EDIÇÃO: $collectionName');
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
        app_logger.Logger.instance
            .info('DELETANDO DOCUMENTO - Coleção: $collectionName, ID: $id');
        app_logger.Logger.instance.info(
            'Dados do documento a ser deletado: ${doc.toPlainMap().toString()}');

        final result = await collection.deleteDocument(
          doc,
          ConcurrencyControl.lastWriteWins,
        );

        if (result) {
          app_logger.Logger.instance
              .info('DOCUMENTO DELETADO COM SUCESSO LOCALMENTE: $id');
          app_logger.Logger.instance.info(
              'Esta exclusão será sincronizada quando houver conexão com a internet');
        } else {
          app_logger.Logger.instance.error('FALHA AO DELETAR DOCUMENTO: $id');
        }

        return result;
      } else {
        app_logger.Logger.instance.error(
            'DOCUMENTO NÃO ENCONTRADO PARA DELEÇÃO: $id na coleção $collectionName');
      }
    } else {
      app_logger.Logger.instance
          .error('FALHA AO CRIAR COLEÇÃO PARA DELEÇÃO: $collectionName');
    }
    return false;
  }
}
