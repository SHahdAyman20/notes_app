import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instant_notes_app/screens/user_account/register/manager/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  void createUserWithEmailAndPassword(
      {required String email, required String password,}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(RegisterSuccessState());

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {

        emit(RegisterFailureState(errorMessage: 'The password provided is too weak!'));
        // showSnackBar( //TODO
        //   message: 'The password provided is too weak.',
        // );
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailureState(errorMessage: 'The account already exists for that email.!'));

        // showSnackBar( //TODO
        //   message: 'The account already exists for that email.',
        // );
      }
    } catch (e) {
      emit(RegisterFailureState(errorMessage: '$e'));

      // showSnackBar(message: '$e'); //TODO
    }
  }

  void saveUserDate({
    required String name,
    required String phone,
    required String email,
  }) {
    final userId = auth.currentUser!.uid;

    final data = {
      'userId': userId,
      'name': name,
      'phone': phone,
      'email': email,
      'imageUrl': ''
    };

    fireStore.collection('users').doc(userId).set(data);
  }
}
