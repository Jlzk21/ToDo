class ToDoModel {
  final int? id;
  final String? title;
  final String? desc;
  final String? dateandtime;

  ToDoModel({this.id, this.title, this.desc, this.dateandtime});

  ToDoModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        desc = res['desc'],
        dateandtime = res['dateandtime'];

  Map<String,Object?> toMap(){
    return {
      "id" : id,
      "title" : title,
      "desc" : desc,
      "dateandtime" : dateandtime,
    };
  }
}
