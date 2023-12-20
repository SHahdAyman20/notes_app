
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginSuccessState extends LoginState {

  final String successMessage;

  LoginSuccessState({required this.successMessage});
}

class LoginFailureState extends LoginState {

  final String errorMessage;
  LoginFailureState({required this.errorMessage});

}

