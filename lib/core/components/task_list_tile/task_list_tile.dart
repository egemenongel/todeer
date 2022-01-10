import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/core/extension/context_extension.dart';
import 'package:to_deer/features/models/list.dart';
import 'package:to_deer/features/services/database_service.dart';
import 'package:to_deer/features/utils/task_list_manager.dart';
import 'package:to_deer/features/views/home/task_list/task_list_view.dart';

class TaskListTile extends StatelessWidget {
  TaskListTile({
    Key? key,
    required this.list,
    required this.listModel,
    required this.index,
  }) : super(key: key);
  final int index;
  final DocumentSnapshot list;
  final ListModel listModel;
  final DatabaseService databaseService = DatabaseService();
  final listTitle = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var _taskListManager = Provider.of<TaskListManager>(context, listen: false);
    return StreamBuilder(
      stream: list.reference.collection("tasks").snapshots(),
      builder: (_, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.indigo,
            ),
          );
        }
        return Slidable(
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.secondary,
              borderRadius: BorderRadius.all(
                context.normalRadius,
              ),
            ),
            child: ListTile(
              title: Text(
                listModel.title,
                style: context.textTheme.bodyText1!
                    .copyWith(color: context.colors.primaryVariant),
              ),
              subtitle: listModel.dueDate != ""
                  ? Row(
                      children: [
                        const Icon(
                          Icons.date_range,
                          size: 12.0,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          listModel.dueDate!,
                          style: context.textTheme.caption!
                              .copyWith(color: context.colors.surface),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                      ],
                    )
                  : null,
              trailing: FutureBuilder(
                future: DatabaseService().getTaskList(list.reference),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) return const SizedBox();
                  _taskListManager.getDone(snapshot);
                  return Text(
                    "${_taskListManager.completedCount}/${snapshot.data.docs.length}",
                    style: context.textTheme.caption!
                        .copyWith(color: context.colors.surface),
                  );
                },
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskListView(
                        list: list,
                      ),
                    ));
              },
            ),
          ),
          actionPane: const SlidableScrollActionPane(),
          actions: [
            SlideAction(
              onTap: () => showDialog(
                context: context,
                builder: (context) => buildDeleteDialog(context),
              ),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
            ),
            SlideAction(
              onTap: () => showDialog(
                context: context,
                builder: (context) => buildEditDialog(context),
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
            ),
          ],
        );
      },
    );
  }

  buildEditDialog(BuildContext context) {
    final listTitle = TextEditingController();
    final _formKey = GlobalKey<FormState>();
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
                    databaseService.editList(snapshot.data, listTitle.text);
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

  buildDeleteDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete List"),
      content: const Text("Do you want to delete this list?"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                DatabaseService().removeList(list);
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
