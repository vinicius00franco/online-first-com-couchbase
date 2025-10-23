import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/checklist_repository.dart';
import '../../utils/logger.dart' as app_logger;
import 'checklist_state.dart';

class FetchChecklistCubit extends Cubit<FetchChecklistState> {
  final ChecklistRepository _repository;

  FetchChecklistCubit(this._repository) : super(FetchChecklistLoading());

  Future<void> fetchItems() async {
    app_logger.Logger.instance
        .info('FetchChecklistCubit: Iniciando busca de itens...');
    try {
      final items = await _repository.fetchAll();
      app_logger.Logger.instance
          .info('FetchChecklistCubit: ${items.length} itens encontrados');
      for (var item in items) {
        app_logger.Logger.instance
            .info('Item: ${item.id} - ${item.title} - Preço: ${item.price}');
      }
      emit(FetchChecklistLoaded(items));
      app_logger.Logger.instance
          .info('FetchChecklistCubit: Estado FetchChecklistLoaded emitido');
    } catch (e) {
      app_logger.Logger.instance
          .error('FetchChecklistCubit: Erro ao buscar itens: $e');
      emit(FetchChecklistError('Erro ao carregar itens: $e'));
    }
  }
}
