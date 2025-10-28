import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/checklist_repository.dart';
import 'checklist_state.dart';

class FetchChecklistCubit extends Cubit<FetchChecklistState> {
  final ChecklistRepository _repository;

  FetchChecklistCubit(this._repository) : super(FetchChecklistLoading());

  Future<void> fetchItems({required String userId}) async {
    try {
      final items = await _repository.fetchAll(userId: userId);
      emit(FetchChecklistLoaded(items));
    } catch (e) {
      emit(FetchChecklistError('Erro ao carregar itens: $e'));
    }
  }
}
