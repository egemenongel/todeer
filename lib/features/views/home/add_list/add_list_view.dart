import 'package:flutter/material.dart';
import 'package:to_deer/core/components/task_form/date_field.dart';
import 'package:to_deer/core/contants/form_constants.dart';
import 'package:to_deer/core/extension/context_extension.dart';
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
        padding: context.paddingMediumHorizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(
              flex: 6,
            ),
            Expanded(flex: 3, child: buildForm()),
            Expanded(
              flex: 1,
              child: buildNextButton(context),
            ),
            const Spacer(
              flex: 6,
            ),
          ],
        ),
      ),
    );
  }

  Form buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: listTitle,
            decoration: InputDecoration(
              labelText: "List Title",
              enabledBorder: listTitle.text.isNotEmpty
                  ? FormConstants.taskFormBorder()
                  : null,
              border: FormConstants.taskFormBorder(),
            ),
            autofocus: true,
            validator: (val) =>
                listTitle.text.isEmpty ? "Please enter a list title" : null,
          ),
          const Spacer(),
          DateField(
            labelText: "Deadline",
            controller: deadline,
          ),
        ],
      ),
    );
  }

  Row buildNextButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
    );
  }
}
