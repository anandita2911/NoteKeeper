import 'package:flutter/material.dart';
import 'package:notekeeper/db/database_provider.dart';
import 'package:notekeeper/model/note_model.dart';

import 'main.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late String title;
  late String body;
  var date;

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  addNote(NoteModel note){
    DatabaseProvider.instance.addNewNote(note);
    print("note added Succesfully");
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12.0),
        child: Column(
          children: [
            TextField(
              controller:titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Note Title",
              ),
              style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: TextField(
                controller: bodyController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Your Note",
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        setState(() {
          title= titleController.text;
          body= bodyController.text;
          date= DateTime.now();
        });
        NoteModel note=
            NoteModel(creation_date: date, title: title, body: body);
        addNote(note)
        ;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
        );

      },
              label: Text("Add note"),
        icon: Icon(Icons.save),
      ),

    );
  }
}

