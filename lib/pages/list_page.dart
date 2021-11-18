import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/widgets/report_widget.dart';
import 'package:to_deer/services/database_service.dart';
import 'package:to_deer/pages/list_title_page.dart';
import 'package:to_deer/services/size_helper.dart';
import 'package:to_deer/utils/task_list_manager.dart';
import 'package:to_deer/widgets/dialogs/add_task_dialog.dart';
import 'package:to_deer/widgets/dialogs/delete_task_dialog.dart';
import 'package:to_deer/widgets/task_tile.dart';

class ListPage extends StatelessWidget {
  const ListPage({Key? key, this.list}) : super(key: key);
  final DocumentSnapshot? list;
  @override
  Widget build(BuildContext context) {
    var firestore = DatabaseService();
    return StreamBuilder(
      stream: firestore.orderedTasks(list!.reference).snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: appBarHeight(context),
            backgroundColor: Colors.red,
            shadowColor: Colors.indigo,
            title: Text(
              "${list!["title"]}",
              style: TextStyle(
                color: Colors.white,
                fontSize: appBarHeight(context) / 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          body: Container(
            color: Colors.red,
            child: Column(
              children: [
                Expanded(
                    child: Container(
                        width: displayWidth(context),
                        padding: const EdgeInsets.only(top: 20),
                        decoration: const BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var task = snapshot.data.docs[index];
                                  return TaskTile(
                                      index: index,
                                      sortedList: firestore
                                          .orderedTasks(list!.reference),
                                      taskTitle: task["title"],
                                      startTime: task["startTime"],
                                      finishTime: task["finishTime"],
                                      duration: task["duration"],
                                      isCompleted: task["isCompleted"],
                                      dueDate: task["dueDate"],
                                      notes: task["notes"],
                                      checkboxCallback: (checkboxState) =>
                                          firestore.checkboxToggle(
                                              task, checkboxState!),
                                      deleteCallback: () => showDialog(
                                            context: context,
                                            builder: (context) =>
                                                DeleteTaskDialog(task: task),
                                          ));
                                },
                                padding: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 5.0,
                                ),
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider(
                                    height: 10,
                                    color: Colors.transparent,
                                  );
                                },
                              ),
                            ),
                            Container(
                              height: bottomBar(context),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                color: Colors.indigoAccent,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  FloatingActionButton(
                                    tooltip: "Add task",
                                    heroTag: null,
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (_) =>
                                          AddTaskDialog(list: list!),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                    ),
                                  ),
                                  FloatingActionButton(
                                    tooltip: "See report",
                                    heroTag: null,
                                    onPressed: () {
                                      Provider.of<TaskListManager>(context,
                                              listen: false)
                                          .sumDuration(snapshot.data.docs);
                                      showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (context) => ReportWidget(
                                            list: list,
                                            title: list!.get("title")),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.pending_actions_rounded,
                                    ),
                                  ),
                                  FloatingActionButton(
                                    tooltip: "Add list",
                                    heroTag: null,
                                    child: const Icon(
                                      Icons.my_library_add_outlined,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ListTitlePage()));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))),
              ],
            ),
          ),
        );
      },
    );
  }
}
