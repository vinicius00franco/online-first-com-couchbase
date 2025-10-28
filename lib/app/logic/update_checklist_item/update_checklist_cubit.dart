import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/checklist_repository.dart';
import 'update_checklist_state.dart';

class UpdateChecklistCubit extends Cubit<UpdateChecklistState> {
  final ChecklistRepository _repository;

  UpdateChecklistCubit(this._repository) : super(UpdateChecklistInitial());

  Future<void> updateItem(
    String uuid, {
    String? title,
    bool? isCompleted,
    double? price,
  }) async {
    try {
      await _repository.updateItem(
        uuid: uuid,
        isCompleted: isCompleted,
        title: title,
        price: price,
      );
      emit(UpdateChecklistSuccess());
    } catch (e) {
      emit(UpdateChecklistError('Erro ao atualizar item: $e'));
    }
  }
}
