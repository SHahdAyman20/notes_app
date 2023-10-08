import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instant_notes_app/model/note.dart';
import 'package:instant_notes_app/screens/note/add_new_note.dart';
import 'package:instant_notes_app/screens/note/edit_note.dart';
import 'package:instant_notes_app/screens/user_account/login_screen.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> note = [
    Note(
        title: 'Film ',
        subTitle: 'Maleficent part 1 ',
        imageUrl: 'https://cdn-icons-png.flaticon.com/512/4021/4021693.png',
        isImportant: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'NOTES',
          style: TextStyle(fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed: (){
              // delete current user data
            FirebaseAuth.instance.signOut();
            // navigate me to the login screen
            Navigator.pushReplacement(
                context, MaterialPageRoute(
                builder: (context) =>const LoginScreen(),
            ),
            );
          }, icon: const Icon(Icons.logout,),)
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
        itemCount: note.length,
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
    ).then((value) => addNewNote(value));
  }

  void addNewNote(value) {
    note.add(value);
    setState(() {});
  }

  void editNote(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => EditNoteScreen(
            note: note[index],
          ),
        )).then((value) => updateNote(index, value));
  }

  void updateNote(int index, value) {
    note[index] = value;
    setState(() {});
  }

  String checkBox(int index) {
    if (note[index].isImportant == true) {
      return ' Important Note';
    } else {
      return '';
    }
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
                  '${note[index].title} ',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Image.network(
                  note[index].imageUrl,
                  width: 40,
                  height: 40,
                ),
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
              note[index].subTitle,
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
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    note.removeAt(index);
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
          if (note[index].isImportant)
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
