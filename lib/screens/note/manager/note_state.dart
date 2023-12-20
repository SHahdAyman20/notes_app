
abstract class NoteState {}

class NoteInitial extends NoteState {}

class GetNoteSuccessState extends NoteState {}

class GetNoteFailureState extends NoteState {

  final String errorMessage;

  GetNoteFailureState({required this.errorMessage});

}

class DeleteNoteSuccessState extends NoteState {}

class DeleteNoteFailureState extends NoteState {

  final String errorMessage;

  DeleteNoteFailureState({required this.errorMessage});

}

class AddNoteSuccessState extends NoteState {}

class UpdateNoteSuccessState extends NoteState {}



