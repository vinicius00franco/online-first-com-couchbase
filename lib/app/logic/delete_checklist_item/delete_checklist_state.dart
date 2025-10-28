abstract class DeleteChecklistState {}

class DeleteChecklistInitial extends DeleteChecklistState {}

class DeleteChecklistSuccess extends DeleteChecklistState {
  final String itemUuid;
  DeleteChecklistSuccess(this.itemUuid);
}

class DeleteChecklistError extends DeleteChecklistState {
  final String message;
  DeleteChecklistError(this.message);
}
