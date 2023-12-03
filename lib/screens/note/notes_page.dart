import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instant_notes_app/model/note.dart';
import 'package:instant_notes_app/screens/note/add_new_note.dart';
import 'package:instant_notes_app/screens/note/edit_note.dart';
import 'package:instant_notes_app/screens/user_account/login_screen.dart';
import 'package:instant_notes_app/screens/user_account/profile_screen.dart';
import 'package:instant_notes_app/shared_preference_singleton/shared_prefernce.dart';
import 'package:instant_notes_app/sqflite_database/database.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  List<Note> myNotes = [];
  final fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;



  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'NOTES',
          style: TextStyle(fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.person,
            ),
          ),
          IconButton(
            onPressed: () {
              // delete current user data
              FirebaseAuth.instance.signOut();

              saveLoggedOut();
              // navigate me to the login screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNoteScreen();
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: ListView.builder(
        itemCount: myNotes.length,
        itemBuilder: (context, index) {
          return buildNote(index);
        },
      ),
    );
  }

// when i click on floating action button to add new note okay
  // so its navigate me to textFormFieldScreen
  // and then is future function work when i back to home to receive the data from pop and add new note
  void addNoteScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => NewNoteScreen(),
        // ,then this future function work when i back to home page to add note
      ),
    ).then((value) => getNotesFromFirebase());
  }

  void addNewNote(value) {
    myNotes.add(value);
    setState(() {});
  }

  void editNote(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => EditNoteScreen(
            note: myNotes[index],
          ),
        )).then((value) => updateNote(index, value));
  }

  void updateNote(int index, value) {
    myNotes[index] = value;
    setState(() {});
  }

  String checkBox(int index) {
    if (myNotes[index].isImportant == true) {
      return ' Important Note';
    } else {
      return '';
    }
  }

  void isLoggedIn() async{
    final loggedIn = PreferenceUtils.getBool(PrefKeys.loggedIn);
    print('loggedIn ====> $loggedIn');

  }

  void saveLoggedOut() async{
    PreferenceUtils.setBool(PrefKeys.loggedIn,false);

  }

  void checkInternetConnection() async{
    final connectivityResult = await (Connectivity().checkConnectivity());
    // now i will check about internet
    // if there is noooo internet => will get notes from database sqflite
    if(connectivityResult == ConnectivityResult.none){
      print('******** offline *********');
      getNotesFromLocalStorage();
    }else{
      print('********* internet connection *********');
      getNotesFromFirebase();
    }
  }

  void getNotesFromFirebase() async{

    final connectivityResult = await (Connectivity().checkConnectivity());
// now i will check about internet
    // if there is noooo internet => will get notes from database sqflite
    if(connectivityResult == ConnectivityResult.none){

      List<Note> notes = await NoteDatabase.getNotesFromDatabase();
      setState(() {
        myNotes = notes;
      });
      // if there is internet in my device => will get notes from firebase
    }else{
      final userId = auth.currentUser!.uid;
      fireStore.collection('notes')
      // where => used to but condition ok?
      //if i didn't the all notes from all accounts will appears
      // but here, it will display just notes from userId of this account
          .where('userId', isEqualTo: userId)
          .get().then((value) {
        myNotes.clear();
        for (var document in value.docs) {
          final note = Note.fromMap(document.data());
          myNotes.add(note);
          print("====> $myNotes");
        }
        print("======================>$myNotes");
        setState(() {});
      }).catchError((error) {
        print("======================>error$error");
      });
    }
  }

  void getNotesFromLocalStorage() async{
    myNotes = await NoteDatabase.getNotesFromDatabase();
    setState(() {});
  }


  Widget buildNote(int index) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[300],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // note title
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
              left: 10,
              top: 5,
              bottom: 10,
            ),
            child: Row(
              children: [
                Text(
                  '${myNotes[index].title} ',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (myNotes[index].imageFromGallery.isNotEmpty)
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.network(myNotes[index].imageFromGallery)
                )
              ],
            ),
          ),
          // note subTitle
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
              left: 10,
              top: 5,
              bottom: 10,
            ),
            child: Text(
              myNotes[index].content,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 19,
              ),
            ),
          ),
          // delete and edit button
          Row(
            children: [
              //delete button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    //delete from database on firebaseStorage
                    fireStore
                        .collection('notes')
                        .doc(myNotes[index].id)
                        .delete();
                    NoteDatabase.deleteNotesFromDatabase(myNotes[index].id);
                    //delete from list
                    myNotes.removeAt(index);
                    setState(() {});

                  },
                  icon: const Icon(
                    Icons.delete_forever,
                  ),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              // edit button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => editNote(index),
                  icon: const Icon(
                    Icons.edit,
                  ),
                  label: const Text('Edit'),
                ),
              ),
            ],
          ),
          // checkbox
          if (myNotes[index].isImportant)
            Padding(
              padding: const EdgeInsets.only(
                right: 10,
                left: 10,
                top: 10,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.note,
                    size: 20,
                  ),
                  Text(
                    checkBox(index),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xff2E5962),
                      // fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

}
