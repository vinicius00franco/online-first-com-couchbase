import 'package:cbl_flutter/cbl_flutter.dart';
// Garante o link da implementação de plataforma (CE) em tempo de build
// ignore: unused_import
import 'package:cbl_flutter_ce/cbl_flutter_ce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app_widget.dart';
import 'app/utils/couchbase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  // Inicializar locale para português brasileiro
  await initializeDateFormatting('pt_BR', null);

  // Inicializar Couchbase Lite sem Vector Search (CE)
  try {
    // Desabilita explicitamente o Vector Search para não tentar carregar a lib nativa
    await CouchbaseLiteFlutter.init(autoEnableVectorSearch: false);
  } on ArgumentError catch (e, s) {
    // Se alguma parte tentar carregar a lib de Vector Search mesmo assim, apenas logamos
    debugPrint('Vector Search não disponível (ignorado): $e');
    debugPrint('Stack: $s');
  } catch (e, s) {
    // Se falhar ao inicializar Couchbase Lite por outro motivo, loga o erro mas continua
    debugPrint('Aviso ao inicializar Couchbase Lite: $e');
    debugPrint('Stack: $s');
    debugPrint('Continuando com a inicialização do app...');
  }

  // Configurar logging do Couchbase Lite (não deve falhar, mas cercamos por segurança)
  try {
    await CouchbaseConfig.configureLogging();
  } catch (e, s) {
    debugPrint(
        'Falha ao configurar logging do Couchbase Lite (seguindo adiante): $e');
    debugPrint('Stack: $s');
  }

  runApp(const MyApp());
}
