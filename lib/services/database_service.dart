import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_deer/models/list.dart';
import 'package:to_deer/models/task.dart';
import 'package:to_deer/utils/task_list_manager.dart';

class DatabaseService {
  String? uid;

  DatabaseService({this.uid}) {
    uid = uid;
  }
  final _firestore = FirebaseFirestore.instance;

  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");
  CollectionReference listsCollection = FirebaseFirestore.instance
      .collection("storage")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("lists");

  Future updateUserData(
    String email,
  ) async {
    return await usersCollection.doc(uid).set({
      "email": email,
    });
  }

  Future<QuerySnapshot> getTaskList(DocumentReference list) async {
    return await list.collection("tasks").get();
  }

  Future<void> addList(
      ListModel listModel, TaskListManager taskListManager) async {
    _firestore
        .collection("storage")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({"storage": "storage"});
    var list = listsCollection.doc();
    list.set(
      listModel.toMap(),
    );
    for (TaskModel task in taskListManager.taskList) {
      list.collection("tasks").doc().set({
        "title": task.title,
        "isCompleted": task.isCompleted,
        "startTime": task.startTime,
        "finishTime": task.finishTime,
        "duration": task.duration,
        "dueDate": task.dueDate,
        "notes": task.notes,
        "timeStamp": Timestamp.now(),
      });
    }
  }

  Future<void> removeList(DocumentSnapshot list) async {
    QuerySnapshot tasks =
        await listsCollection.doc(list.id).collection("tasks").get();
    list.reference.update({"listTitle": FieldValue.delete()});
    for (var task in tasks.docs) {
      task.reference.delete();
    }

    list.reference.delete();
  }

  void editList(DocumentSnapshot doc, String newTitle) {
    doc.reference.update({"title": newTitle});
  }

  Query orderedTasks(DocumentReference doc) {
    return doc.collection("tasks").orderBy("timeStamp");
  }

  Future addTask(DocumentReference list, TaskModel task) async {
    await list.collection("tasks").add(task.toMap());
  }

  removeTask(QueryDocumentSnapshot task) async {
    task.reference.delete();
  }

  void editTask(QueryDocumentSnapshot doc, TaskModel task) {
    doc.reference.update(task.toMap());
  }

  void checkboxToggle(QueryDocumentSnapshot doc, bool checkboxState) {
    doc.reference.update({"isCompleted": checkboxState});
  }
}
