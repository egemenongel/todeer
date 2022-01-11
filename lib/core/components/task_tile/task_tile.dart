import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_deer/core/components/task_form/task_form.dart';
import 'package:to_deer/core/contants/form_constants.dart';
import 'package:to_deer/core/extension/context_extension.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_deer/features/models/task.dart';
import 'package:to_deer/features/services/database_service.dart';

class TaskTile extends StatelessWidget {
  TaskTile({
    Key? key,
    required this.index,
    required this.checkboxCallback,
    required this.deleteCallback,
    required this.sortedList,
    required this.task,
  }) : super(key: key);
  final int index;
  final Query sortedList;
  final TaskModel task;
  final void Function(bool?)? checkboxCallback;
  final void Function()? deleteCallback;
  final DatabaseService database = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.secondary,
          borderRadius: BorderRadius.all(
            context.normalRadius,
          ),
        ),
        child: ListTile(
            horizontalTitleGap: 2.0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                      color:
                          (index % 2) == 1 ? Colors.indigo : Colors.blue[900],
                      decoration: task.isCompleted!
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor:
                          (index % 2) == 1 ? Colors.orange : Colors.deepOrange),
                ),
                Row(
                  children: [
                    if (task.dueDate!.isNotEmpty) ...[
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            size: 12.0,
                            color: Colors.indigo[900],
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            "${DateTime.parse(task.dueDate!).day} ${FormConstants.months[DateTime.parse(task.dueDate!).month - 1]} ",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                        ],
                      ),
                    ] else ...[
                      const SizedBox(),
                    ],
                    if (task.notes!.isNotEmpty) ...[
                      Icon(
                        Icons.sticky_note_2_sharp,
                        color: Colors.indigo[900],
                        size: 12.0,
                      ),
                    ],
                  ],
                ),
              ],
            ),
            leading: Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              value: task.isCompleted,
              onChanged: checkboxCallback,
              activeColor: (index % 2) == 1 ? Colors.orange : Colors.deepOrange,
            ),
            trailing: SizedBox(
              width: context.width / 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  task.duration != ""
                      ? Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "${task.duration!} mins",
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.white),
                          ),
                        )
                      : const SizedBox(),
                  task.startTime != ""
                      ? Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.green[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            task.startTime!,
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.white),
                          ),
                        )
                      : const SizedBox(),
                  task.finishTime != "" && task.startTime != ""
                      ? const SizedBox(
                          width: 2.0,
                        )
                      : const SizedBox(),
                  task.finishTime != ""
                      ? Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.red[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            task.finishTime!,
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.white),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            )),
      ),
      actionPane: const SlidableStrechActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: [
        SlideAction(
          onTap: () => showDialog(
            context: context,
            builder: (_) => buildEditTaskDialog(context),
            // EditTaskDialog(
            //   index: index,
            //   sortedList: sortedList,
            // ),
          ),
          child: const Icon(
            Icons.mode_edit_outlined,
            color: Colors.white,
          ),
          decoration: const BoxDecoration(
            color: Colors.grey,
          ),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: SlideAction(
            onTap: deleteCallback,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  buildEditTaskDialog(BuildContext context) {
    final taskTitle = TextEditingController();
    final startTime = TextEditingController();
    final finishTime = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    final duration = TextEditingController();
    final dueDate = TextEditingController();
    final notes = TextEditingController();
    return StreamBuilder(
      stream: sortedList.snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        //SET INITIAL VALUES
        var task = snapshot.data.docs[index];
        taskTitle.text = task["title"];
        startTime.text = task["startTime"];
        finishTime.text = task["finishTime"];
        duration.text = task["duration"];
        dueDate.text = task["dueDate"];
        notes.text = task["notes"];
        return AlertDialog(
          scrollable: true,
          backgroundColor: Colors.red,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          contentPadding: EdgeInsets.zero,
          titlePadding: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(
                color: Colors.red,
              )),
          content: TaskForm(
            formKey: _formKey,
            taskTitle: taskTitle,
            startTime: startTime,
            finishTime: finishTime,
            duration: duration,
            dueDate: dueDate,
            notes: notes,
          ),
          actions: [
            TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    database.editTask(
                        task,
                        TaskModel(
                          title: taskTitle.text,
                          startTime: startTime.text,
                          finishTime: finishTime.text,
                          duration: duration.text,
                          dueDate: dueDate.text,
                          notes: notes.text,
                          timeStamp: task["timeStamp"], //To make it same
                          isCompleted: task["isCompleted"],
                        ));
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
}
