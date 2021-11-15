import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_deer/services/database_service.dart';

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
        return SizedBox(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Colors.deepPurple,
                )),
            title: const Text("Change List Name"),
            content: Form(
              key: _formKey,
              child: SizedBox(
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  controller: listTitle,
                  validator: (val) => listTitle.text.isEmpty
                      ? "Please enter a list title"
                      : null,
                ),
                height: 250.0,
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
                  child: const Text("Edit")),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"))
            ],
            actionsAlignment: MainAxisAlignment.spaceBetween,
          ),
          height: 300.0,
        );
      },
    );
  }
}
