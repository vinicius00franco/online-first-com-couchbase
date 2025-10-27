import 'package:flutter/material.dart';

// Imports comentados para uso futuro
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'logic/add_checklist_item/add_checklist_cubit.dart';
import 'logic/checklist/checklist_cubit.dart';
import 'logic/delete_checklist_item/delete_checklist_cubit.dart';
import 'logic/update_checklist_item/update_checklist_cubit.dart';
import 'pages/checklist_page.dart';
import 'repositories/checklist_repository.dart';
import 'services/couchbase_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // 4. O MaterialApp é essencial. Ele fornece todas as ferramentas
//     //    básicas de design (Material Design), navegação e temas.
//     //    Sem ele, a tela fica preta.
//     return MaterialApp(
//       // Desativa o banner "DEBUG" no canto superior direito
//       debugShowCheckedModeBanner: false,

//       // 'home' é a primeira tela que será exibida.
//       home: MinhaHomePage(),
//     );
//   }
// }

// // 5. Esta é a tela principal (Widget de Página)
// class MinhaHomePage extends StatelessWidget {
//   const MinhaHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // 6. O 'Scaffold' é o andaime da tela. Ele fornece a estrutura
//     //    visual básica, como a barra de aplicativo (AppBar) e o corpo (body).
//     //    Sem ele, a tela também ficaria preta (ou vazia).
//     return Scaffold(
//       // A barra no topo da tela
//       appBar: AppBar(
//         title: const Text('Meu App Simples'),
//         backgroundColor: Colors.blue, // Cor de fundo da barra
//       ),

//       // O conteúdo principal da tela
//       body: const Center(
//         // Centraliza o conteúdo filho
//         child: Text(
//           'Olá, Mundo! Isto funciona.',
//           style: TextStyle(fontSize: 20), // Estilo do texto
//         ),
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    print('🎨 [MYAPP] Iniciando construção do MaterialApp...');

    final theme = AppTheme.light();
    print('🎨 [MYAPP] Tema criado: ${theme.primaryColor}');

    print('🎨 [MYAPP] Criando MultiProvider...');

    return MultiProvider(
      providers: [
        Provider(create: (context) => CouchbaseService()),

        // Fornece o ChecklistRepository
        Provider(
          create: (context) => ChecklistRepository(
            couchbaseService: context.read<CouchbaseService>(),
          ),
        ),
        // Fornece os Cubits, que usam o mesmo repositório
        BlocProvider(
          create: (context) => FetchChecklistCubit(
            context.read<ChecklistRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => AddChecklistCubit(
            context.read<ChecklistRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => UpdateChecklistCubit(
            context.read<ChecklistRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => DeleteChecklistCubit(
            context.read<ChecklistRepository>(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          print('🎨 [MYAPP] Construindo MaterialApp...');

          return MaterialApp(
            title: 'Checklist',
            locale: const Locale('pt', 'BR'),
            theme: theme,
            home: const ChecklistPage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
