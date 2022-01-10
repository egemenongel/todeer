import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_deer/core/contants/form_constants.dart';
import 'package:to_deer/core/extension/context_extension.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_deer/features/models/task.dart';
import 'package:to_deer/features/views/list/dialogs/edit_task_dialog.dart';

class TaskTile extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const TaskTile({
    required this.index,
    required this.checkboxCallback,
    required this.deleteCallback,
    required this.sortedList,
    required this.task,
  });

  final int index;
  final Query sortedList;
  final TaskModel task;
  final void Function(bool?)? checkboxCallback;
  final void Function()? deleteCallback;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Container(
        decoration: BoxDecoration(
            color: (index % 2) == 1 ? Colors.blue[100] : Colors.white,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10), topLeft: Radius.circular(10))),
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
            builder: (_) => EditTaskDialog(
              index: index,
              sortedList: sortedList,
            ),
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
}