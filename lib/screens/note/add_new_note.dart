import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instant_notes_app/const_functions/const.dart';
import 'package:instant_notes_app/model/note.dart';
import 'package:instant_notes_app/screens/note/manager/note_cubit.dart';
import 'package:instant_notes_app/sqflite_database/database.dart';
import 'package:instant_notes_app/widgets/custom_text_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NewNoteScreen extends StatefulWidget {

  Note? note;

  NewNoteScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return NewNoteScreenState();
  }
}

class NewNoteScreenState extends State<NewNoteScreen> {

  late NoteCubit cubit ;



  final titleController = TextEditingController();
  final subTitleController = TextEditingController();
  String imageFromGallery = '';

  bool isImportant=false;

  final formKey = GlobalKey<FormState>();

  final fireStore = FirebaseFirestore.instance;
  final fireStorage = FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;

  // Generate a unique filename using timestamp
  String uniqueImageFileId = DateTime.now().microsecondsSinceEpoch.toString();


  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<NoteCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text('Add Note',style: GoogleFonts.aBeeZee(
            fontSize: 22.sp,
            color: Colors.white
        ),),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // title text form field
                 SizedBox(
                  height: 10.sp,
                ),
                CustomTextField(
                  maxLine: 1,
                  controller: titleController,
                  type: TextInputType.text,
                  action: TextInputAction.next,
                  hintText: 'Enter Note Title',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'The title is required !';
                    }
                    if (value!.length < 3) {
                      return 'The title is very small !';
                    }
                    return null;
                  },
                ),
                 SizedBox(
                  height: 10.sp,
                ),
                // subTitle text form field
                CustomTextField(
                  maxLine: null,
                  controller: subTitleController,
                  type: TextInputType.text,
                  action: TextInputAction.done,
                  hintText: 'Enter Note Content',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'The content is required !';
                    }
                    return null;
                  },
                ),
                 SizedBox(
                  height: 10.sp,
                ),
                // image button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor
                  ),
                    onPressed: () => pickImageFromGallery(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.upload_rounded,color: Colors.white,),
                        Text(
                          'Upload Image from gallery',
                          style: TextStyle(fontSize: 18.sp,color: Colors.white),
                        ),
                      ],
                    )
                ),
                 SizedBox(
                  height: 10.sp,
                ),
                // check box for note is important or not
                CheckboxListTile(
                  title: const Text('Important Note'),
                  value: isImportant,
                  onChanged: (value) {
                    setState(() {
                      isImportant = value!;
                    });
                  },
                ),
                 SizedBox(
                  height: 10.sp,
                ),
                SizedBox(
                  width: double.infinity,
                  //  height: 10,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor
                    ),
                    child:  Text(
                      'Add Note',
                      style: TextStyle(fontSize: 22.sp,color: Colors.white),
                    ),
                    onPressed: () => addNewNote(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addNewNote() {
    // if my current state not validate don't complete code
    if (!formKey.currentState!.validate()) {
      return;
    }
    String title = titleController.text;
    String subTitle = subTitleController.text;
    String id= DateTime.now().microsecondsSinceEpoch.toString();
    String imageFromGallery=this.imageFromGallery;



    final note = Note(
      title: title,
      content: subTitle,
      isImportant: isImportant,
        id: id,
      imageFromGallery: imageFromGallery
    );
    NoteDatabase.insertNotesToDatabase(note);
    print(note);
    fireStore.collection('notes').doc(id).set(note.toMap());
    // here i told him to take this title , subTitle,image url and return it back to display in screen
    Navigator.pop(context, note);
  }


  // pick Note image from gallery
  // upload image to firebase storage
  // get image url from firebase storage
// save image url to FireBaseFireStore database

  void pickImageFromGallery() async{

    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(
        source: ImageSource.gallery
    );//when i choose a picture
        if(file !=null){
      final image = File(file.path);
// it will be uploaded
      uploadImageToFireStorage(image);
    }else{

        }
  }

  void uploadImageToFireStorage(File image){

    String fileName = 'NoteImage/$uniqueImageFileId';

    fireStorage.ref(fileName).putFile(image).then((value){
      print('Note image => success');
      getImageUrl(fileName);
    }).catchError((onError){
      print('Note image => $onError');
    });
  }

  void getImageUrl(String fileName){
    fireStorage.ref(fileName)
        .getDownloadURL()
        .then((imageUrl){
      print(imageUrl);
      setState(() {
        imageFromGallery = imageUrl;
      });
      saveImageToFireBase();
    })
        .catchError((onError){
      print('Failed to get image URL: $onError');

    });
  }

  void saveImageToFireBase(){
    if(imageFromGallery.isNotEmpty){
      fireStore
          .collection('notes')
          .doc(widget.note!.id)
          .update({'imageFromGallery': imageFromGallery});
    }
  }


}
