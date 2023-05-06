import 'package:flutter/material.dart';
import 'package:group2/db/database.dart';
import 'package:group2/db/model/model.dart';
import 'package:intl/intl.dart';



class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  DatabaseHelper? dbHelper;
  late Future<List<ToDoModel>> dataList;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    loadListData();
  }

  loadListData() async {
    dataList = dbHelper!.getTodoList();
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: titleController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Note Title:"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter text";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: descController,
                      maxLines: null,
                      minLines: 10,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Note Description:"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter text";
                        }
                        return null;
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      titleController.clear();
                      descController.clear();
                    });
                  },
                  child: const Text("CLEAR"))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            dbHelper!.insert(ToDoModel(
                title: titleController.text,
                desc: descController.text,
                dateandtime: DateFormat('yMd')
                    .add_jm()
                    .format(DateTime.now())
                    .toString()));
            Navigator.popAndPushNamed(context, "/");
            titleController.clear();
            descController.clear();
          }
        },
      ),
    );
  }
}
