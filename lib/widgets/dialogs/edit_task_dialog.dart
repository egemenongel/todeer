import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_deer/models/task_model.dart';
import 'package:to_deer/services/database_service.dart';
import 'package:to_deer/widgets/task_form.dart';

class EditTaskDialog extends StatelessWidget {
  EditTaskDialog({
    Key? key,
    required this.index,
    required this.sortedList,
  }) : super(key: key);
  final int index;
  final Query sortedList;
  final DatabaseService firestore = DatabaseService();
  final taskTitle = TextEditingController();
  final startTime = TextEditingController();
  final finishTime = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final duration = TextEditingController();
  final dueDate = TextEditingController();
  final notes = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: sortedList.snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        //SET INITIAL VALUES
        var task = snapshot.data.docs[index];
        taskTitle.text = task["title"];
        startTime.text = task["startTime"];
        finishTime.text = task["finishTime"];
        duration.text = task["duration"];
        dueDate.text = task["dueDate"];
        notes.text = task["notes"];
        return AlertDialog(
          backgroundColor: Colors.orange,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          contentPadding: EdgeInsets.zero,
          titlePadding: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Colors.orange,
              )),
          content: SingleChildScrollView(
            child: TaskForm(
              formKey: _formKey,
              taskTitle: taskTitle,
              startTime: startTime,
              finishTime: finishTime,
              duration: duration,
              dueDate: dueDate,
              notes: notes,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    firestore.editTask(
                        task,
                        TaskModel(
                          title: taskTitle.text,
                          startTime: startTime.text,
                          finishTime: finishTime.text,
                          duration: duration.text,
                          dueDate: dueDate.text,
                          notes: notes.text,
                          timeStamp: task["timeStamp"], //To make it same
                          isCompleted: task["isCompleted"],
                        ));
                    Navigator.pop(context);
                  }
                },
                child: const Text("Edit")),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"))
          ],
          actionsAlignment: MainAxisAlignment.spaceBetween,
        );
      },
    );
  }
}
