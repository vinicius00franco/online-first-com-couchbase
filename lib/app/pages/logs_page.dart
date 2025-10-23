import 'package:flutter/material.dart';
import '../utils/couchbase_config.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  List<String> _logFiles = [];
  String _selectedLogContent = '';
  String _selectedFileName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogFiles();
  }

  Future<void> _loadLogFiles() async {
    setState(() => _isLoading = true);

    try {
      final logFiles = await CouchbaseConfig.getLogFiles();
      setState(() {
        _logFiles = logFiles.map((file) => file.path.split('/').last).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar logs: $e')),
        );
      }
    }
  }

  Future<void> _loadLogContent(String fileName) async {
    setState(() => _isLoading = true);

    try {
      final content = await CouchbaseConfig.readLogFile(fileName);
      setState(() {
        _selectedLogContent = content;
        _selectedFileName = fileName;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar log: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs do Couchbase Lite'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLogFiles,
            tooltip: 'Atualizar lista de logs',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _logFiles.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum arquivo de log encontrado.\nExecute o app para gerar logs.',
                    textAlign: TextAlign.center,
                  ),
                )
              : Row(
                  children: [
                    // Lista de arquivos de log
                    SizedBox(
                      width: 200,
                      child: ListView.builder(
                        itemCount: _logFiles.length,
                        itemBuilder: (context, index) {
                          final fileName = _logFiles[index];
                          final isSelected = fileName == _selectedFileName;

                          return ListTile(
                            title: Text(
                              fileName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            selected: isSelected,
                            onTap: () => _loadLogContent(fileName),
                          );
                        },
                      ),
                    ),
                    // Conteúdo do log selecionado
                    Expanded(
                      child: _selectedLogContent.isEmpty
                          ? const Center(
                              child: Text(
                                  'Selecione um arquivo de log para visualizar'),
                            )
                          : SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: SelectableText(
                                _selectedLogContent,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }
}
