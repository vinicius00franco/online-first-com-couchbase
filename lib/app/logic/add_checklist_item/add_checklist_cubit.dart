import 'package:flutter_bloc/flutter_bloc.dart';
import '../../entities/shopping_item_entity.dart';
import '../../repositories/checklist_repository.dart';
import '../../utils/uuid_helper.dart';
import 'add_checklist_state.dart';

class AddChecklistCubit extends Cubit<AddChecklistState> {
  final ChecklistRepository _repository;
  final UuidHelper _uuidHelper;

  AddChecklistCubit(this._repository, this._uuidHelper)
      : super(AddChecklistInitial());

  Future<void> addItem({
    required String userId,
    required String title,
    required double price,
  }) async {
    try {
      final uuid = _uuidHelper.generate();
      final item = ShoppingItemEntity(
        uuid: uuid,
        userId: userId,
        title: title,
        isCompleted: false,
        price: price,
        createdAt: DateTime.now(),
      );
      await _repository.addItem(item);
      emit(AddChecklistSuccess(item));
    } catch (e) {
      emit(AddChecklistError('Erro ao adicionar item: $e'));
    }
  }
}
