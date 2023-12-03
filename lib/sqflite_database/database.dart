import 'package:instant_notes_app/model/note.dart';
import 'package:sqflite/sqflite.dart';

class NoteDatabase{
  // i made this class like shared preferences singleton, to not create object
 // evert time i want make thing, i just will call this database object
// i made it static to access it easily

  static Database? database;

  static Future<void> init() async{

    await openDatabase(
        'notes.db',
        version: 1,
        // onCreate func => work just 1 time when i create database
        onCreate: (Database db, int version) async {
          print('database created !');
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE Notes (id TEXT, userId TEXT, title TEXT, content TEXT, imageFromGallery TEXT)');
          print('table created !');

        },
        // onOpen func => work every time i open app
        onOpen: (db){
        print('database opened !');
        database = db;
      }
        );
  }
  // CRUD => create, read, update, delete

  static void insertNotesToDatabase(Note note) async {
   // Insert some records in a transaction
   await database!.transaction((txn) async {
     int id1 = await txn.rawInsert(
         'INSERT INTO Notes (id , userId , title , content , imageFromGallery) VALUES ("${note.id}", "${note.userId}", "${note.title}", "${note.content}" ,"${note.imageFromGallery}")');
     print('inserted1 ============> $id1');
   });
 }

  static Future<List<Note>> getNotesFromDatabase() async {
   // Get the records
   List<Map> list = await database!.rawQuery('SELECT * FROM Notes');
   print(list);
   return list.map((e) => Note.fromMap(e)).toList();


 }

  static void updateNotesOnDatabase(Note note) async{
   // Update some record
   int count = await database!.rawUpdate(
       'UPDATE Notes SET title = ?, content = ?, imageFromGallery = ? WHERE id = ?',
       ['${note.title}', '${note.content}','${note.imageFromGallery}','${note.id}']);
   print('updated ==========> $count');
 }

  static void deleteNotesFromDatabase(String id) async{
   // Delete a record
   await database!
       .rawDelete('DELETE FROM Notes WHERE id = ?', ['$id']);

 }


}