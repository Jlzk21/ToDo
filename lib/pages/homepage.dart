import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group2/db/database.dart';
import 'package:group2/db/model/model.dart';
import 'package:intl/intl.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:group2/pages/viewedit.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper? dbHelper;
  late Future<List<ToDoModel>> dataList;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    loadListData();
  }

  loadListData() async {
    dataList = dbHelper!.getTodoList();
  }

  isFirstRun() async {
    if (await IsFirstRun.isFirstRun()) {
      dbHelper!.insert(ToDoModel(
          title: "Hola!",
          desc:
              "This is our Group 2 Simple ToDo App running on flutter using Sqflite dependencies, this Database is working on mobile devices only.",
          dateandtime:
              DateFormat('yMd').add_jm().format(DateTime.now()).toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    isFirstRun();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: const [
            Text("Todo"),
            Text(
              "Group-2",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: dataList,
            builder: (BuildContext context,
                AsyncSnapshot<List<ToDoModel>> snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("No Notes Found"),
                );
              } else {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      int todoId = snapshot.data![index].id!.toInt();
                      String todoTitle =
                          snapshot.data![index].title!.toString();
                      String todoDesc = snapshot.data![index].desc!.toString();
                      String todoDateAndTime =
                          snapshot.data![index].dateandtime!.toString();

                      return Dismissible(
                        key: ValueKey<int>(todoId),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          child: const Icon(Icons.delete_forever),
                        ),
                        confirmDismiss: (DismissDirection direction) async {
                          showCupertinoModalPopup<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                              title: const Text('Alert'),
                              content: Text(
                                  "Do you want to delete this note named: $todoTitle?"),
                              actions: <CupertinoDialogAction>[
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('No'),
                                ),
                                CupertinoDialogAction(
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    setState(() {
                                      dbHelper!.deleteItem(todoId);
                                      dataList = dbHelper!.getTodoList();
                                      snapshot.data!
                                          .remove(snapshot.data![index]);
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          );

                          return null;
                        },
                        child: Tooltip(
                          message: "Edit/View Note",
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewEditNote(
                                            todoId: todoId,
                                            todoTitle: todoTitle,
                                            todoDesc: todoDesc,
                                            todoDateTime: todoDateAndTime,
                                            todoEdit: true,
                                          )));
                            },
                            child: Card(
                              margin: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.all(10.0),
                                    title: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        todoTitle,
                                        style: const TextStyle(fontSize: 19),
                                      ),
                                    ),
                                    subtitle: Text(
                                      todoDateAndTime,
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              }
            },
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ViewEditNote(
                    todoId: 0,
                    todoTitle: '',
                    todoDesc: '',
                    todoDateTime: '',
                    todoEdit: false,
                  )));
        },
      ),
    );
  }
}
