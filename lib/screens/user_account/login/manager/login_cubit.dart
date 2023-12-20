import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instant_notes_app/screens/user_account/login/manager/login_state.dart';
import 'package:instant_notes_app/shared_preference_singleton/shared_prefernce.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  void signInWithEmailAndPassword({
    required String email,
    required String pass
}) async {

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
    emit(LoginSuccessState(successMessage: 'Signed In Successfully ✔️'));
      // showSnackBar(message: 'Signed In Successfully ✔️');
      //TODO
      // saveLoggedIn();
      //
      // navToNotesScreen();

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailureState(errorMessage: 'No user found for that email!'));
        // showSnackBar(message: 'No user found for that email!');
      }else if(e.code =='INVALID_LOGIN_CREDENTIALS'){
        emit(LoginFailureState(errorMessage: 'Wrong password provided for that user!!'));

        // showSnackBar(message: 'Wrong password provided for that user!');
      }
    } catch (e) {
      print(e);
      emit(LoginFailureState(errorMessage: e.toString()));

      // showSnackBar(message: 'Error signing in: $e');
    }

  }
  // save login data in local storage by shared preference package


  void saveLoggedIn() async {
    PreferenceUtils.setBool(PrefKeys.loggedIn, true);
  }

}
