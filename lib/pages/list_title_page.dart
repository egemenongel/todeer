import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/pages/add_list_page.dart';
import 'package:to_deer/utils/task_list_manager.dart';

class ListTitlePage extends StatelessWidget {
  ListTitlePage({Key? key}) : super(key: key);
  final listTitle = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 50.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: listTitle,
                decoration: const InputDecoration(
                    labelText: "List Title",
                    labelStyle: TextStyle(fontSize: 14)),
                autofocus: true,
                validator: (val) =>
                    listTitle.text.isEmpty ? "Please enter a list title" : null,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<TaskListManager>().setTitle(listTitle.text);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AddListPage()));
                }
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
