import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instant_notes_app/const_functions/const.dart';
import 'package:instant_notes_app/model/note.dart';
import 'package:instant_notes_app/sqflite_database/database.dart';
import 'package:instant_notes_app/widgets/custom_text_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditNoteScreen extends StatefulWidget {

  Note note;

  EditNoteScreen({required this.note, super.key});
  @override
  State<StatefulWidget> createState() {
    return NewNoteScreenState();
  }
}

class NewNoteScreenState extends State<EditNoteScreen> {

  final titleController= TextEditingController();
  final subTitleController= TextEditingController();
  String imageFromGallery = '';

  bool isImportant=false;
  final formKey=GlobalKey<FormState>();

  final fireStore= FirebaseFirestore.instance;
  final fireStorage = FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    titleController.text= widget.note.title;
    subTitleController.text=widget.note.content;
    isImportant= widget.note.isImportant;
    imageFromGallery= widget.note.imageFromGallery;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text('Edit Note',style: GoogleFonts.aBeeZee(
            fontSize: 22.sp,
            color: Colors.white
        ),),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(12.0.sp),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                 SizedBox(
                  height: 10.sp,
                ),
                // title text form field
                CustomTextField(
                  maxLine: 1,
                  controller: titleController,
                  type: TextInputType.text,
                  action: TextInputAction.next,
                  hintText: 'Enter Note Title',
                  validator: (value){
                    if(value!.isEmpty){
                      return 'The title is required !';
                    }
                    if(value!.length < 3){
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
                  controller: titleController,
                  type: TextInputType.text,
                  action: TextInputAction.next,
                  hintText: 'Enter Note Content',
                  validator: (value){
                    if(value!.isEmpty){
                      return 'The sub title is required !';
                    }
                    return null;
                  },
                ),
                 SizedBox(
                  height: 10.sp,
                ),
                // upload another image from gallery button
                ElevatedButton(
                    onPressed: ()=> pickImageFromGallery(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor
                    ),
                    child:const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_rounded,color: Colors.white,),
                        Text('Upload another Image from gallery',style: TextStyle(color: Colors.white),)
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
                // update note button
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
                    child: const Text(
                      'Update Note',
                      style: TextStyle(fontSize: 22,color: Colors.white),
                    ),
                    onPressed: () => updateNote(),

                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void updateNote(){
    // if my current state not validate don't complete code
    if(!formKey.currentState!.validate()){
      return;
    }
    String title=titleController.text;
    String subTitle = subTitleController.text;
    String imageFromGallery= this.imageFromGallery;

    fireStore.
    collection('notes').
    doc(widget.note.id).
    update({
      'title': title,
      'subTitle': subTitle,
      'isImportant': isImportant,
      'imageFromGallery': imageFromGallery
    });

    final note = Note(
        title: title,
        content: subTitle,
        isImportant: isImportant,
        id: widget.note.id,
        imageFromGallery: imageFromGallery
    );
    NoteDatabase.updateNotesOnDatabase(note);

    // here i told him to take this editing title, subTitle and return it back to display in screen
    Navigator.pop(context,note);
  }


  // pick image from gallery
  // upload image to firebase storage
  // get image url from firebase storage
// save image url to FireBaseFireStore database
  // update image if i choose a different image

  void pickImageFromGallery() async{

    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(
        source: ImageSource.gallery
    );
    if (file != null) {
      final image = File(file.path);
      uploadImageToFireStorage(image, updateImageFromGallery);
    }else{

    }
    //when i choose a picture
    // it will be uploaded
  }

  void uploadImageToFireStorage(File image, Function(String) callback){

    fireStorage.ref('NoteImage/${widget.note.id}').putFile(image).then((value){
      print('Note image => success');
      getImageUrl();
    }).catchError((onError){
      print('Note image => $onError');
    });
  }

  void getImageUrl(){
    fireStorage
        .ref('NoteImage/${widget.note.id}')
        .getDownloadURL()
        .then((imageUrl){
      print(imageUrl);
      setState(() {
        imageFromGallery = imageUrl;
      });
      saveImageToFireBase();
    })
        .catchError((onError){});
  }

  void saveImageToFireBase(){

    fireStore
        .collection('notes')
        .doc(widget.note.id)
        .update({
      'imageFromGallery': imageFromGallery
    }).then((_) {
      print('Image URL saved to Firestore');
    }).catchError((error) {
      print('Failed to save image URL: $error');
    });
  }

  void updateImageFromGallery(String imagePath) {
    setState(() {
      imageFromGallery = imagePath;
    });
  }
}