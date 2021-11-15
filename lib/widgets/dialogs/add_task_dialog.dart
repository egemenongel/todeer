import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_deer/models/task.dart';
import 'package:to_deer/services/database_service.dart';
import 'package:to_deer/widgets/task_form.dart';

class AddTaskDialog extends StatelessWidget {
  AddTaskDialog({Key? key, required this.list}) : super(key: key);
  final DocumentSnapshot? list;
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
    return AlertDialog(
      backgroundColor: Colors.orange,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      contentPadding: EdgeInsets.zero,
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
                firestore.addTask(
                    list!.reference,
                    TaskModel(
                      title: taskTitle.text,
                      isCompleted: false,
                      startTime: startTime.text,
                      finishTime: finishTime.text,
                      duration: duration.text,
                      dueDate: dueDate.text,
                      timeStamp: Timestamp.now(),
                      notes: notes.text,
                    ));
                Navigator.pop(context);
              }
            },
            child: const Text("Add")),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"))
      ],
      actionsAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}
