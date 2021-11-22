import 'package:flutter/material.dart';
import 'package:to_deer/models/list.dart';
import 'package:to_deer/pages/add_list/add_tasks_page.dart';
import 'package:to_deer/shared/form_constants.dart';
import 'package:to_deer/shared/task_form/date_field.dart';

class AddListPage extends StatelessWidget {
  AddListPage({Key? key}) : super(key: key);
  final listTitle = TextEditingController();
  final deadline = TextEditingController();
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
              child: Column(
                children: [
                  TextFormField(
                    controller: listTitle,
                    decoration: InputDecoration(
                        labelText: "List Title",
                        labelStyle: const TextStyle(fontSize: 14),
                        enabledBorder:
                            listTitle.text.isNotEmpty ? taskFormBorder() : null,
                        border: taskFormBorder()),
                    autofocus: true,
                    validator: (val) => listTitle.text.isEmpty
                        ? "Please enter a list title"
                        : null,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  DateField(
                    labelText: "Deadline",
                    controller: deadline,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ListModel list = ListModel(
                    title: listTitle.text,
                    dueDate: deadline.text,
                  );
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddTasksPage(list: list)));
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
