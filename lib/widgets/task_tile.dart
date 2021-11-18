import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_deer/services/size_helper.dart';
import 'package:to_deer/widgets/dialogs/edit_task_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskTile extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const TaskTile({
    required this.index,
    required this.taskTitle,
    required this.startTime,
    required this.finishTime,
    required this.duration,
    required this.dueDate,
    required this.notes,
    required this.isCompleted,
    required this.checkboxCallback,
    required this.deleteCallback,
    required this.sortedList,
  });

  final int index;
  final Query sortedList;
  final String taskTitle;
  final String startTime;
  final String finishTime;
  final String duration;
  final String dueDate;
  final String notes;
  final bool isCompleted;
  final void Function(bool?)? checkboxCallback;
  final void Function()? deleteCallback;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            color: (index % 2) == 1 ? Colors.blue[100] : Colors.white,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10), topLeft: Radius.circular(10))),
        child: ListTile(
            horizontalTitleGap: 10.0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskTitle,
                  style: TextStyle(
                      color:
                          (index % 2) == 1 ? Colors.indigo : Colors.blue[900],
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor:
                          (index % 2) == 1 ? Colors.orange : Colors.deepOrange),
                ),
                Row(
                  children: [
                    if (dueDate.isNotEmpty) ...[
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
                            dueDate,
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
                    if (notes.isNotEmpty) ...[
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
              value: isCompleted,
              onChanged: checkboxCallback,
              activeColor: (index % 2) == 1 ? Colors.orange : Colors.deepOrange,
            ),
            trailing: Container(
              alignment: Alignment.center,
              width: displayWidth(context) / 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  duration != ""
                      ? Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "$duration mins",
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      : const SizedBox(),
                  startTime != ""
                      ? Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.green[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            startTime,
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      : const SizedBox(),
                  finishTime != "" && startTime != ""
                      ? const SizedBox(
                          width: 2.0,
                        )
                      : const SizedBox(),
                  finishTime != ""
                      ? Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.red[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            finishTime,
                            style: const TextStyle(color: Colors.white),
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
            border: Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 1,
              ),
              top: BorderSide(
                color: Colors.black,
                width: 1,
              ),
            ),
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
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
                top: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
