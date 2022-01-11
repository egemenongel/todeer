import 'package:flutter/material.dart';

import 'package:to_deer/core/contants/form_constants.dart';
import 'package:to_deer/core/extension/context_extension.dart';
import 'package:to_deer/features/models/list.dart';
import 'package:to_deer/features/views/home/add_tasks/add_tasks_view.dart';

class AddListView extends StatefulWidget {
  const AddListView({Key? key}) : super(key: key);

  @override
  State<AddListView> createState() => _AddListViewState();
}

class _AddListViewState extends State<AddListView> {
  final listTitle = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final deadline = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(context.lowRadius),
          color: context.colors.secondary,
        ),
        padding: EdgeInsets.only(
            bottom: context.mediaQuery.viewInsets.bottom,
            left: context.normalValue,
            right: context.normalValue,
            top: context.normalValue),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: buildForm(context),
                ),
                Expanded(
                  flex: 1,
                  child: buildNextButton(context),
                ),
              ],
            ),
          ],
        ));
  }

  Form buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: listTitle,
            decoration: InputDecoration(
              labelText: "List Title",
              labelStyle: context.textTheme.bodyText1!.copyWith(
                color: context.colors.primary,
              ),
              enabledBorder: listTitle.text.isNotEmpty
                  ? FormConstants.taskFormBorder()
                  : null,
              border: FormConstants.taskFormBorder(),
            ),
            autofocus: true,
            validator: (val) =>
                listTitle.text.isEmpty ? "Please enter a list title" : null,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2050),
                ),
                icon: const Icon(
                  Icons.date_range,
                ),
              ),
              IconButton(
                onPressed: () => showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2050),
                ),
                icon: const Icon(
                  Icons.note_add,
                ),
              ),
            ],
          ),
          // DateField(
          //   labelText: "Deadline",
          //   controller: deadline,
          // ),
        ],
      ),
    );
  }

  Padding buildNextButton(BuildContext context) {
    return Padding(
      padding: context.paddingLow,
      child: IconButton(
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
        icon: Icon(
          Icons.arrow_forward,
          color: context.colors.primary,
        ),
      ),
    );
  }
}
