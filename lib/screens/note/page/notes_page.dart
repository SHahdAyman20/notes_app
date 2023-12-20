import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instant_notes_app/const_functions/const.dart';
import 'package:instant_notes_app/screens/note/add_new_note.dart';
import 'package:instant_notes_app/screens/note/edit_note.dart';
import 'package:instant_notes_app/screens/note/manager/note_cubit.dart';
import 'package:instant_notes_app/screens/note/manager/note_state.dart';
import 'package:instant_notes_app/screens/user_account/login/page/login_screen.dart';
import 'package:instant_notes_app/screens/user_account/profile_screen.dart';
import 'package:instant_notes_app/shared_preference_singleton/shared_prefernce.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final cubit = NoteCubit();

  @override
  void initState() {
    super.initState();
    cubit.checkInternetConnection();
    isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
          title: Text('NOTES',
              style: GoogleFonts.aboreto(
                fontSize: 23.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600
              )),
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
                color: Colors.white,
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
                color: Colors.white,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          onPressed: () {
            addNoteScreen();
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: BlocBuilder<NoteCubit, NoteState>(
          buildWhen: (previous, current) {
            return current is GetNoteSuccessState ||
                current is DeleteNoteSuccessState ||
                current is UpdateNoteSuccessState;
          },
          builder: (context, state) {
            print('note state =====> ${state.runtimeType}');
            if (cubit.myNotes.isEmpty) {
              return  Center(
                child: Text(
                  'No notes available',
                  style: TextStyle(fontSize: 20.sp),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: cubit.myNotes.length,
                itemBuilder: (context, index) {
                  return buildNote(index);
                },
              );
            }
          },
        ),
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
        builder: (BuildContext context) => BlocProvider.value(
          value: cubit,
          child: NewNoteScreen(),
        ),
        // ,then this future function work when i back to home page to add note
      ),
    ).then((value) => cubit.getNotesFromFireStore());
  }

  void editNote(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => EditNoteScreen(
            note: cubit.myNotes[index],
          ),
        )).then((value) => cubit.updateNote(index, value));
  }

  String checkBox(int index) {
    if (cubit.myNotes[index].isImportant == true) {
      return ' Important Note';
    } else {
      return '';
    }
  }

//TODO
  //  colorPicker(BuildContext context){
  //   return showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text('Change Note color'),
  //         content: TextButton(
  //           onPressed: () {  },
  //           child: Text('Select'),
  //         ),
  //       )
  //   );
  // }

  void isLoggedIn() async {
    final loggedIn = PreferenceUtils.getBool(PrefKeys.loggedIn);
    print('loggedIn ====> $loggedIn');
  }

  void saveLoggedOut() async {
    PreferenceUtils.setBool(PrefKeys.loggedIn, false);
  }

  Widget buildNote(int index) {
    return Container(
      padding:  EdgeInsets.all(15.sp),
      margin:  EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.sp),
        color: Colors.grey[300],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // note title
          Padding(
            padding:  EdgeInsets.only(
              right: 10.sp,
              left: 10.sp,
              top: 5.sp,
              bottom: 10.sp,
            ),
            child: Row(
              children: [
                Text('${cubit.myNotes[index].title} ',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.adamina(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    )),
                const Spacer(),
                if (cubit.myNotes[index].imageFromGallery.isNotEmpty)
                  SizedBox(
                      width: 30.sp,
                      height: 30.sp,
                      child:
                          Image.network(cubit.myNotes[index].imageFromGallery))
              ],
            ),
          ),
          // note subTitle
          Padding(
            padding:  EdgeInsets.only(
              right: 10.sp,
              left: 10.sp,
              top: 5.sp,
              bottom: 10.sp,
            ),
            child: Text(
              cubit.myNotes[index].content,
              maxLines: null,
              style:  TextStyle(
                fontSize: 22.sp,
              ),
            ),
          ),
          // delete and edit button
          Row(
            children: [
              //delete button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => cubit.deleteNote(index: index),
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
               SizedBox(
                width: 10.sp,
              ),
              // edit button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => editNote(index),
                  icon: Icon(
                    Icons.edit,
                    color: primaryColor,
                  ),
                  label: Text(
                    'Edit',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ),
            ],
          ),
          // checkbox
          if (cubit.myNotes[index].isImportant)
            Padding(
              padding:  EdgeInsets.only(
                right: 10.sp,
                left: 10.sp,
                top: 10.sp,
              ),
              child: Row(
                children: [
                   Icon(
                    Icons.note,
                    size: 20.sp,
                  ),
                  Text(
                    checkBox(index),
                    style:  TextStyle(
                      fontSize: 18.sp,
                      color:const Color(0xff2E5962),
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
