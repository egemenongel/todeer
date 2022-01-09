import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_deer/features/services/database_service.dart';

class DeleteListDialog extends StatelessWidget {
  const DeleteListDialog({Key? key, this.list}) : super(key: key);
  final DocumentSnapshot? list;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete List"),
      content: const Text("Do you want to delete this list?"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                DatabaseService().removeList(list!);
                Navigator.pop(context);
              },
              child: const Text("Yes"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
            ),
          ],
        )
      ],
    );
  }
}
