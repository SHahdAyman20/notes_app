import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instant_notes_app/const_functions/const.dart';
import 'package:instant_notes_app/shared_preference_singleton/shared_prefernce.dart';
import 'package:instant_notes_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
  final fireStorage = FirebaseStorage.instance;
  String imageUrl='';
  bool isLoading=false;

  @override
  void initState() {
    super.initState();
    getUserDateFromLocalDataSource();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        iconTheme:const IconThemeData(color: Colors.white),

      ),
      body: ListView(
        children: [
           Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                const SizedBox(
                  height: 8,
                ),
                // profile picture
                if(imageUrl.isEmpty)
                InkWell(
                  onTap: ()=> pickImageFromGallery(),
                  child: Align(
                    alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white,
                        child: Icon(
                            Icons.person,
                          size: 50,
                          color: primaryColor,
                        )
                      ),
                  ),
                ),
                if(imageUrl.isNotEmpty)
                    Stack(
                      alignment: Alignment.center,
                    children: [
                      InkWell(
                        onTap: ()=> pickImageFromGallery(),
                        child: Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(imageUrl),
                          ),
                        ),
                      ),
                     Visibility(
                       visible: isLoading,
                         child: const CircularProgressIndicator()
                     )
                    ],
                  ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Container(
            width: screenWidth,
            height: screenHeight,
            padding: const EdgeInsets.only(
              top: 50,
              left: 25,
              right: 25,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                //name text field
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Name ',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    bottom: 20,top: 10,
                  ),
                  child: CustomTextField(
                    maxLine: 1,
                    controller: nameController,
                    type: TextInputType.name,
                    action: TextInputAction.next,
                    hintText: 'Enter your name',
                    prefixIcon:const Icon(Icons.person),
                  ),
                ),
                //phone number text field
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Phone Number ',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: CustomTextField(
                    maxLine: 1,
                    controller: phoneController,
                    type: TextInputType.number,
                    action: TextInputAction.next,
                    maxLength: 11,
                    hintText: 'Enter your Phone Number',
                    prefixIcon:const Icon(Icons.phone),
                  ),
                ),
                //email text field
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Email ',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    bottom: 20,top: 10,
                  ),
                  child: CustomTextField(
                    enable: false,
                    maxLine: 1,
                    controller: emailController,
                    type: TextInputType.emailAddress,
                    action: TextInputAction.next,
                    hintText: 'Enter your email address',
                    prefixIcon:const Icon(Icons.email),
                  ),
                ),
                // Updated button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    minimumSize:
                    Size(
                        MediaQuery.of(context).size.width * 0.79, 50
                    ),
                  ),
                  onPressed: () {
                    saveUserDate();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                       color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void saveUserDate() {
    final userId = auth.currentUser!.uid;

    final data = {
      'name': nameController.text,
      'phone': phoneController.text,
    };

    fireStore.collection('users').doc(userId).update(data);
  }

  void getUserInfo(){
     fireStore.collection('users').
        doc(auth.currentUser!.uid).get().
           then((value) {
             updateUi(value.data()!);
     }).catchError((onError){

     });
  }

  void saveUserDateInLocalDataSource(Map<String, dynamic> map) async{
    final json = jsonEncode(map);
    PreferenceUtils.setString(PrefKeys.userData, json);
  }

  void getUserDateFromLocalDataSource() async{
    final json = PreferenceUtils.getString(PrefKeys.userData);
    final userData = jsonDecode(json??'');
    print('userData ==> $userData');
    updateUi(userData);
  }

  void updateUi(Map<String, dynamic> data) {

    nameController.text= data['name'];
    phoneController.text= data['phone'];
    emailController.text= data['email'];

    setState(() {
      imageUrl = data['imageUrl'];
    });
  }


   // pick image frm gallery
  // upload image to firebase storage
 // get image url from firebase storage
// save image url to FireBaseFireStore database

 void pickImageFromGallery() async{

  final ImagePicker picker = ImagePicker();
  final XFile? file = await picker.pickImage(
      source: ImageSource.gallery
  );//when i choose a picture
  final image = File(file!.path);
  // it will be uploaded
  uploadImageToFireStorage(image);

}

 void uploadImageToFireStorage(File image){
    final userId=auth.currentUser!.uid;
    setState(() {
      isLoading =  true;
    });
    fireStorage.ref('profileImage/$userId').putFile(image).then((value){
      print('profile image => success');
      getImageUrl();
    }).catchError((onError){
      print('profile image => $onError');
      setState(() {
        isLoading =  false;
      });
    });
}

 void getImageUrl(){
    fireStorage.ref('profileImage/Image')
        .getDownloadURL()
        .then((imageUrl){
          print(imageUrl);
          setState(() {
            this.imageUrl =  imageUrl;
            isLoading =  false;
          });
          saveImageToFireBase();
    })
        .catchError((onError){});
  }

 void saveImageToFireBase(){

    final userId = auth.currentUser!.uid;
    
    fireStore.collection('users').doc(userId)
        .update({
          'imageUrl': imageUrl
        });
}

}


