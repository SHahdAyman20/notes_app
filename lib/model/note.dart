import 'package:firebase_auth/firebase_auth.dart';

class Note {
  String id ='';
  String userId ='';
  String title='' ;
  String content='';
  String imageFromGallery='';
  bool isImportant =false;


  Note({
     required this.title,
     required this.content,
    required this.isImportant,
    required this.id,
    required this.imageFromGallery
  }){
    userId = FirebaseAuth.instance.currentUser!.uid;
  }

  Note.fromMap(Map<dynamic,dynamic> data){
    id = data['id'];
    userId = data['userId'];
    title = data['title'];
    content = data['subTitle'];
    imageFromGallery= data['imageFromGallery'];
  }

  Map<String,dynamic> toMap(){
    return{
      'id': id,
      'userId': userId,
      'title': title,
      'subTitle': content,
      'imageFromGallery': imageFromGallery
    };
  }

}
