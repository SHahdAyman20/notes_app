import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instant_notes_app/model/note.dart';
import 'package:instant_notes_app/sqflite_database/database.dart';

class NewNoteScreen extends StatefulWidget {

  Note? note;

  @override
  State<StatefulWidget> createState() {
    return NewNoteScreenState();
  }
}

class NewNoteScreenState extends State<NewNoteScreen> {

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
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // title text form field
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: titleController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'The title is required !';
                    }
                    if (value!.length < 3) {
                      return 'The title is very small !';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Title'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // subTitle text form field
                TextFormField(
                  maxLines: null,
                  controller: subTitleController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'The content is required !';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Content'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // image button
                ElevatedButton(
                    onPressed: () => pickImageFromGallery(),
                    child:const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_rounded),
                        Text(
                          'Upload Image from gallery',
                          style: TextStyle(fontSize: 18),)
                      ],
                    )
                ),
                const SizedBox(
                  height: 10,
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
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  //  height: 10,
                  child: ElevatedButton(
                    child: const Text(
                      'Add Note',
                      style: TextStyle(fontSize: 22),
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
      final image = File(file!.path);
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
