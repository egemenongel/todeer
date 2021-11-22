import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/models/list.dart';
import 'package:to_deer/pages/list/list_page.dart';
import 'package:to_deer/services/database_service.dart';
import 'package:to_deer/utils/task_list_manager.dart';
import 'package:to_deer/pages/home/delete_list_dialog.dart';
import 'package:to_deer/pages/home/edit_list_dialog.dart';

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
                border: Border.all(color: Colors.white),
                color: index % 2 == 1
                    ? Colors.lightBlue[200]
                    : Colors.lightBlue[900],
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(40),
                )),
            child: ListTile(
              tileColor: Colors.white,
              title: Text(
                listModel.title,
                style: TextStyle(
                    color: index % 2 == 1 ? Colors.indigo[800] : Colors.white),
              ),
              // subtitle: Row(
              //   children: [
              //     Icon(
              //       Icons.date_range,
              //       size: 12.0,
              //       color: index % 2 == 1 ? Colors.indigo[800] : Colors.white,
              //     ),
              //     const SizedBox(
              //       width: 5.0,
              //     ),
              //     Text(
              //       list["dueDate"],
              //       style: TextStyle(
              //         color: index % 2 == 1 ? Colors.indigo[800] : Colors.white,
              //         fontSize: 10.0,
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 5.0,
              //     ),
              //   ],
              // ),
              trailing: FutureBuilder(
                future: DatabaseService().getTaskList(list.reference),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) return const SizedBox();
                  _taskListManager.getDone(snapshot);
                  return Text(
                    "${_taskListManager.completedCount}/${snapshot.data.docs.length}",
                    style: TextStyle(
                        color:
                            index % 2 == 1 ? Colors.indigo[800] : Colors.white),
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
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              child: SlideAction(
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
            ),
            Container(
              decoration: const BoxDecoration(
                  border: Border(
                bottom: BorderSide(color: Colors.white),
                top: BorderSide(
                  color: Colors.white,
                ),
              )),
              child: SlideAction(
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
            ),
          ],
        );
      },
    );
  }
}
