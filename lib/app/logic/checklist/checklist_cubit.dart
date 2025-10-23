import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/checklist_repository.dart';
import 'checklist_state.dart';

class FetchChecklistCubit extends Cubit<FetchChecklistState> {
  final ChecklistRepository _repository;

  FetchChecklistCubit(this._repository) : super(FetchChecklistLoading());

  Future<void> fetchItems() async {
    print('FetchChecklistCubit: Iniciando busca de itens...');
    try {
      final items = await _repository.fetchAll();
      print('FetchChecklistCubit: ${items.length} itens encontrados');
      for (var item in items) {
        print('Item: ${item.id} - ${item.title} - Preço: ${item.price}');
      }
      emit(FetchChecklistLoaded(items));
      print('FetchChecklistCubit: Estado FetchChecklistLoaded emitido');
    } catch (e) {
      print('FetchChecklistCubit: Erro ao buscar itens: $e');
      emit(FetchChecklistError('Erro ao carregar itens: $e'));
    }
  }
}
