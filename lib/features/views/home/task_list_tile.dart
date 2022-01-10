import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/features/models/list.dart';
import 'package:to_deer/features/services/database_service.dart';
import 'package:to_deer/features/utils/task_list_manager.dart';
import 'package:to_deer/features/views/home/delete_list_dialog.dart';
import 'package:to_deer/features/views/home/edit_list_dialog.dart';
import 'package:to_deer/features/views/list/task_list_view.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({
    Key? key,
    required this.list,
    required this.listModel,
    required this.index,
  }) : super(key: key);
  final int index;
  final DocumentSnapshot list;
  final ListModel listModel;

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
                color: index % 2 == 1
                    ? const Color(0xff393E9E)
                    : const Color(0xff272A6B),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                )),
            child: ListTile(
              tileColor: Colors.white,
              title: Text(
                listModel.title,
                style: TextStyle(
                    color: index % 2 == 1 ? Colors.white : Colors.white),
              ),
              subtitle: listModel.dueDate != ""
                  ? Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          size: 12.0,
                          color: index % 2 == 1 ? Colors.white : Colors.white,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          listModel.dueDate!,
                          style: TextStyle(
                            color: index % 2 == 1 ? Colors.white : Colors.white,
                            fontSize: 10.0,
                          ),
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
                    style: TextStyle(
                        color: index % 2 == 1 ? Colors.white : Colors.white),
                  );
                },
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListPage(
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
                builder: (context) => DeleteListDialog(list: list),
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
                builder: (context) => EditListDialog(
                  list: list,
                ),
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
}
