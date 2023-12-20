

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterSuccessState extends RegisterState {}

class RegisterFailureState extends RegisterState {

  final String errorMessage;

  RegisterFailureState({required this.errorMessage});

}

