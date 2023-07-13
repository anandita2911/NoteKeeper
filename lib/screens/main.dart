import 'package:flutter/material.dart';
import 'package:notekeeper/db/database_provider.dart';
import 'package:notekeeper/screens/add_note.dart';
import 'package:notekeeper/screens/add_note.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => HomeScreen(),
        "/Addnote":(context) =>AddNote(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> notesFuture;

  @override
  void initState() {
    super.initState();
    notesFuture = getNotes();
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    final notes = await DatabaseProvider.instance.getNotes();
    return notes;
  }

  Future<void> refreshNotes() async {
    setState(() {
      notesFuture = getNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Notes"),
      ),
      body: RefreshIndicator(
        onRefresh: refreshNotes,
        backgroundColor: Colors.indigo,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: notesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final noteData = snapshot.data;
              if (noteData == null || noteData.isEmpty) {
                return Center(
                  child: Text("You don't have any notes yet. Create one."),
                );
              } else {
                return Dismissible(
                  background:  Container(
                    color: Colors.red,
                    child: Icon(Icons.delete_forever),
                    
                  ),
                 onDismissed: (DismissDirection direction){
                    
                 },
                  key: null,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: noteData.length,
                      itemBuilder: (context, index) {
                        final title = noteData[index]['title'];
                        final body = noteData[index]['body'];
                        final creationDate = noteData[index]['creation_date'];
                        final id = noteData[index]['id'];

                        return Card(
                          child: ListTile(
                            title: Text(title),
                            subtitle: Text(body),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/Addnote").then((_) {
            refreshNotes();
          });
        },
        child: Icon(Icons.note_add),
      ),
    );
  }
}









