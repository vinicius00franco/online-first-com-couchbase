import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  // Inicializar locale para português brasileiro
  await initializeDateFormatting('pt_BR', null);

  await CouchbaseLiteFlutter.init();

  runApp(const MyApp());
}
