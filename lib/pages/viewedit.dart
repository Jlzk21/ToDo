import 'package:flutter/material.dart';
import 'package:group2/db/database.dart';
import 'package:group2/model/model.dart';
import 'package:intl/intl.dart';
import 'package:undo/undo.dart';

class ViewEditNote extends StatefulWidget {
  final int? todoId;
  final String? todoTitle;
  final String? todoDesc;
  final String? todoDateTime;
  final bool? todoEdit;

  const ViewEditNote(
      {super.key,
        this.todoId,
        this.todoTitle,
        this.todoDesc,
        this.todoDateTime,
        this.todoEdit});

  @override
  State<StatefulWidget> createState() => _ViewEditNoteState();
}

class _ViewEditNoteState extends State<ViewEditNote> {
  DatabaseHelper? dbHelper;
  late Future<List<ToDoModel>> dataList;
  final _formKey = GlobalKey<FormState>();
  late SimpleStack _controller;
  late String history;

  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void initState() {

    _controller = SimpleStack<String>(
      "",
      onUpdate: (val) {
        if (mounted) {
          setState(() {
            history = val;
          });
        }
      },
    );
    super.initState();
    dbHelper = DatabaseHelper();
    loadListData();
    titleController.text = widget.todoTitle!;
    descController.text = widget.todoDesc!;
  }

  loadListData() async {
    dataList = dbHelper!.getTodoList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: widget.todoEdit == true ? const Text("View/Edit") : const Text("Add Note"),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: !_controller.canUndo
                ? null
                : () {
              if (mounted) {
                setState(() {
                  _controller.undo();
                  descController.text = history;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: !_controller.canRedo
                ? null
                : () {
              if (mounted) {
                setState(() {
                  _controller.redo();
                  descController.text = history;
                });
              }
            },
          ),
          IconButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (widget.todoEdit == true) {
                    dbHelper!.updateItem(ToDoModel(
                        id: widget.todoId,
                        title: titleController.text,
                        desc: descController.text,
                        dateandtime: DateFormat('yMd')
                            .add_jm()
                            .format(DateTime.now())
                            .toString()));

                  } else {
                    dbHelper!.insert(ToDoModel(
                        title: titleController.text,
                        desc: descController.text,
                        dateandtime: DateFormat('yMd')
                            .add_jm()
                            .format(DateTime.now())
                            .toString()));
                  }

                  Navigator.popAndPushNamed(context, "/");
                  titleController.clear();
                  descController.clear();
                }
              },
              icon: const Icon(Icons.save))
        ],
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
                      onChanged: (text) {
                        _controller.modify(text);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
