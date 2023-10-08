import 'package:flutter/material.dart';
import 'package:instant_notes_app/model/note.dart';

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
  final imageUrlController= TextEditingController();

  bool isImportant=false;
  final formKey=GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController.text= widget.note.title;
    subTitleController.text=widget.note.subTitle;
    imageUrlController.text=widget.note.imageUrl;
    isImportant= widget.note.isImportant;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
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
                  validator: (value){
                    if(value!.isEmpty){
                      return 'The title is required !';
                    }
                    if(value!.length < 3){
                      return 'The title is very small !';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('Title'),
                  ),
                ),
                // subTitle text form field
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: subTitleController,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'The title is required !';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Content'),
                  ),
                ),
                // image text form field
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: imageUrlController,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'The Image URL is required !';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Image URL'),
                  ),
                ),
                // check box for note is important or not
                const SizedBox(
                  height: 10,
                ),
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
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  //  height: 10,
                  child: ElevatedButton(
                    child: const Text(
                      'Update Note',
                      style: TextStyle(fontSize: 22),
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
    String imageUrl = imageUrlController.text;
    final note = Note(
      title: title,
      subTitle: subTitle,
      imageUrl: imageUrl,
      isImportant: isImportant
    );
    // here i told him to take this editing title, subTitle and return it back to display in screen
    Navigator.pop(context,note);
  }
}
