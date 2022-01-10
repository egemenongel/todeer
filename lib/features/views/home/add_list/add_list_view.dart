import 'package:flutter/material.dart';
import 'package:to_deer/core/components/task_form/date_field.dart';
import 'package:to_deer/core/contants/form_constants.dart';
import 'package:to_deer/features/models/list.dart';
import 'package:to_deer/features/views/home/add_tasks/add_tasks_view.dart';

class AddListView extends StatelessWidget {
  AddListView({Key? key}) : super(key: key);
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
                      enabledBorder: listTitle.text.isNotEmpty
                          ? FormConstants.taskFormBorder()
                          : null,
                      border: FormConstants.taskFormBorder(),
                    ),
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
                          builder: (context) => AddTasksView(list: list)));
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
