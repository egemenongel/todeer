import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/core/extension/context_extension.dart';
import 'package:to_deer/features/utils/task_list_manager.dart';
import 'package:to_deer/features/views/add_list/add_list_view.dart';
import 'package:to_deer/features/views/list/dialogs/add_task_dialog.dart';

class ReportSheet extends StatelessWidget {
  const ReportSheet({
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
                        text: title,
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