import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instant_notes_app/model/note.dart';
import 'package:instant_notes_app/screens/note/manager/note_state.dart';
import 'package:instant_notes_app/sqflite_database/database.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(NoteInitial());

  List<Note> myNotes = [];
  final fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;


  void getNotesFromFireStore() async{

    final connectivityResult = await (Connectivity().checkConnectivity());
// now i will check about internet
    // if there is noooo internet => will get notes from database sqflite
    if(connectivityResult == ConnectivityResult.none){

      getNotesFromLocalStorage();
      // myNotes = await NoteDatabase.getNotesFromDatabase();
      // // setState(() {
      // //   myNotes = notes;
      // // });
      // if there is internet in my device => will get notes from firebase
    }else{
      final userId = auth.currentUser!.uid;
      fireStore.collection('notes')
      // where => used to but condition ok?
      //if i didn't the all notes from all accounts will appears
      // but here, it will display just notes from userId of this account
          .where('userId', isEqualTo: userId)
          .get().
      then((value) {
        myNotes.clear();
        for (var document in value.docs) {
          final note = Note.fromMap(document.data());
          myNotes.add(note);
          print("====> $myNotes");
        }
        emit(GetNoteSuccessState());
        // setState(() {});
      }).catchError((error) {
        emit(GetNoteFailureState(errorMessage: 'error message ===>${error.toString()}'));
      //  print("======================>error$error");
      });
    }
  }

  void checkInternetConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    // now i will check about internet
    // if there is noooo internet => will get notes from database sqflite
    if (connectivityResult == ConnectivityResult.none) {
      print('******** offline *********');
      getNotesFromLocalStorage();
    } else {
      print('********* internet connection *********');
      getNotesFromFireStore();
    }
  }


  void getNotesFromLocalStorage() async {
    myNotes = await NoteDatabase.getNotesFromDatabase();
    emit(GetNoteSuccessState());
    // setState(() {});
  }

  void deleteNote({required int index}){
   // delete from database on firebaseStorage

    fireStore
        .collection('notes')
        .doc(myNotes[index].id).
    delete();
    NoteDatabase.deleteNotesFromDatabase(myNotes[index].id);
    //delete from list
    myNotes.removeAt(index);
    emit(DeleteNoteSuccessState());
    // setState(() {});
  }

  void addNewNote({required Note note}) {
    myNotes.add(note);
    emit(AddNoteSuccessState());
    // setState(() {});
  }

  void updateNote(int index, value) {
    myNotes[index] = value;
    emit(UpdateNoteSuccessState());
    // setState(() {});
  }

}
