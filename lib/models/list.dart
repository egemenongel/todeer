class ListModel {
  String title;
  String? dueDate;

  ListModel({required this.title, this.dueDate}) {
    title = title;
    dueDate = dueDate;
  }
  Map<String, dynamic> toMap() {
    //model to map
    return {
      "title": title,
      "dueDate": dueDate,
    };
  }
}
