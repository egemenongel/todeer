import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/pages/list_title_page.dart';
import 'package:to_deer/services/size_helper.dart';
import 'package:to_deer/utils/task_list_manager.dart';
import 'package:to_deer/widgets/dialogs/add_task_dialog.dart';

class ReportWidget extends StatelessWidget {
  const ReportWidget({
    Key? key,
    required this.list,
    required this.title,
  }) : super(key: key);
  final String title;
  final DocumentSnapshot? list;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: displayHeight(context) / 2,
          width: displayWidth(context),
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
                "You have totally spent",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    )),
                child: Text(
                  Provider.of<TaskListManager>(context).total.toString() +
                      " minutes",
                  style: const TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 30.0,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text("on $title tasks"),
              Container(
                height: bottomBar(context),
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
                                builder: (context) => ListTitlePage()));
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

class ReportDialog extends StatelessWidget {
  ReportDialog({Key? key, required this.title}) : super(key: key);
  String title;
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Container(
          height: displayHeight(context) / 2,
          width: displayWidth(context),
          decoration: const BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                topLeft: Radius.circular(10.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("You have totally spent "),
              const SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.white,
                child: Text(
                  Provider.of<TaskListManager>(context).total.toString(),
                  style: TextStyle(color: Colors.cyan),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text("minutes on $title tasks"),
            ],
          ),
        ),
      ],
    );
  }
}
