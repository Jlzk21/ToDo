import 'package:flutter/material.dart';
import 'package:group2/db/database.dart';
import 'package:group2/db/model/model.dart';
import 'package:intl/intl.dart';

class UpdateNote extends StatefulWidget {

  final int? todoId;
  final String? todoTitle;
  final String? todoDesc;
  final String? todoDateTime;

  const UpdateNote(
      {super.key,
      this.todoId,
      this.todoTitle,
      this.todoDesc,
      this.todoDateTime,
      });

  @override
  State<StatefulWidget> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {

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

    final titleController = TextEditingController(text: widget.todoTitle);
    final descController = TextEditingController(text: widget.todoDesc);


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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            dbHelper!.updateItem(ToDoModel(
                id: widget.todoId,
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
