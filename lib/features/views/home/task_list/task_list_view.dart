import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/core/extension/context_extension.dart';
import 'package:to_deer/features/models/task.dart';
import 'package:to_deer/features/services/database_service.dart';
import 'package:to_deer/features/utils/task_list_manager.dart';
import 'package:to_deer/features/views/home/add_list/add_list_view.dart';
import 'package:to_deer/core/components/add_task_dialog/add_task_dialog.dart';
import 'package:to_deer/core/components/task_tile/task_tile.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({Key? key, this.list}) : super(key: key);
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
            toolbarHeight: context.appBarHeight,
            backgroundColor: Colors.red,
            shadowColor: Colors.indigo,
            title: Text(
              "${list!["title"]}",
              style: TextStyle(
                color: Colors.white,
                fontSize: context.appBarHeight / 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          body: Container(
            color: Colors.red,
            child: Container(
                width: context.width,
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
                              task: TaskModel(
                                title: task["title"],
                                startTime: task["startTime"],
                                finishTime: task["finishTime"],
                                duration: task["duration"],
                                isCompleted: task["isCompleted"],
                                dueDate: task["dueDate"],
                                notes: task["notes"],
                              ),
                              sortedList:
                                  firestore.orderedTasks(list!.reference),
                              checkboxCallback: (checkboxState) => firestore
                                  .checkboxToggle(task, checkboxState!),
                              deleteCallback: () => showDialog(
                                    context: context,
                                    builder: (context) =>
                                        buildDeleteDialog(context, task),
                                  ));
                        },
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 5.0,
                        ),
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            height: 10,
                            color: Colors.transparent,
                          );
                        },
                      ),
                    ),
                    Container(
                      height: context.bottomBar,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Colors.indigoAccent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FloatingActionButton(
                            tooltip: "Add task",
                            heroTag: null,
                            onPressed: () => showDialog(
                              context: context,
                              builder: (_) => AddTaskDialog(list: list!),
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
                                builder: (context) => buildReportSheet(context),
                              );
                              //    ReportSheet(
                              //       list: list, title: list!.get("title")),
                              // );
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
                                      builder: (context) => AddListView()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }

  buildDeleteDialog(BuildContext context, dynamic task) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: const Text("Delete task"),
      content: const Text("Do you want to delete this task?"),
      actions: [
        TextButton(
          child: const Text("Yes"),
          onPressed: () {
            DatabaseService().removeTask(task);
            Navigator.pop(context);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        TextButton(
          child: const Text("No"),
          onPressed: () => Navigator.pop(context),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
      ],
    );
  }

  buildReportSheet(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: context.height / 2,
          width: context.width,
          decoration: const BoxDecoration(
            color: Colors.indigoAccent,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                topLeft: Radius.circular(10.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "You totally spent",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                height: 60.0,
                width: 200.0,
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(
                      10.0,
                    )),
                child: Center(
                  child: Text(
                    "${context.read<TaskListManager>().total} minutes",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                  text: "on ",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                  children: [
                    TextSpan(
                        text: "${list!.get("title")}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    const TextSpan(text: " tasks"),
                  ],
                ),
              ),
              Container(
                height: context.bottomBar,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.indigoAccent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FloatingActionButton(
                      tooltip: "Add task",
                      heroTag: null,
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) => SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      AddTaskDialog(list: list!),
                                    ],
                                  ),
                                ));
                      },
                      child: const Icon(
                        Icons.add,
                      ),
                    ),
                    FloatingActionButton(
                      tooltip: "See report",
                      heroTag: null,
                      onPressed: () => Navigator.pop(context),
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
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddListView()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
