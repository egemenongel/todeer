import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_deer/features/services/database_service.dart';

class EditListDialog extends StatelessWidget {
  EditListDialog({Key? key, required this.list}) : super(key: key);
  final DatabaseService firestore = DatabaseService();
  final listTitle = TextEditingController();
  final DocumentSnapshot list;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: list.reference.snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        listTitle.text = snapshot.data["title"];
        return AlertDialog(
          backgroundColor: Colors.red,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          contentPadding: EdgeInsets.zero,
          titlePadding: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(
                color: Colors.red,
              )),
          content: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.deepOrange[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: _formKey,
              child: TextFormField(
                autofocus: true,
                controller: listTitle,
                validator: (val) =>
                    listTitle.text.isEmpty ? "Please enter a list title" : null,
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    firestore.editList(snapshot.data, listTitle.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  "Edit",
                  style: TextStyle(color: Colors.white),
                )),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ))
          ],
          actionsAlignment: MainAxisAlignment.spaceBetween,
        );
      },
    );
  }
}
