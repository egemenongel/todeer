import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_deer/features/services/database_service.dart';

class DeleteTaskDialog extends StatelessWidget {
  const DeleteTaskDialog({
    Key? key,
    required this.task,
  }) : super(key: key);
  final QueryDocumentSnapshot task;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: const Text("Delete task"),
      content: const Text("Do you want to delete this task?"),
      actions: [
        TextButton(
          child: const Text("Yes"),
          onPressed: () {
            DatabaseService().removeTask(task);
            Navigator.pop(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        TextButton(
          child: const Text("No"),
          onPressed: () => Navigator.pop(context),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
      ],
    );
  }
}
