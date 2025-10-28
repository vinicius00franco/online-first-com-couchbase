import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/checklist_repository.dart';
import 'delete_checklist_state.dart';

class DeleteChecklistCubit extends Cubit<DeleteChecklistState> {
  final ChecklistRepository _repository;

  DeleteChecklistCubit(this._repository) : super(DeleteChecklistInitial());

  Future<void> deleteItem(String uuid) async {
    try {
      await _repository.deleteItem(uuid);
      emit(DeleteChecklistSuccess(uuid));
    } catch (e) {
      emit(DeleteChecklistError('Erro ao excluir item: $e'));
    }
  }
}
