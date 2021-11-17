import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/services/size_helper.dart';
import 'package:to_deer/utils/task_list_manager.dart';
import 'package:to_deer/widgets/form_fields/date_field.dart';
import 'package:to_deer/widgets/form_fields/time_field.dart';

class TaskForm extends StatefulWidget {
  TaskForm({
    Key? key,
    required this.formKey,
    required this.taskTitle,
    required this.startTime,
    required this.finishTime,
    required this.duration,
    required this.dueDate,
    required this.notes,
  }) : super(key: key);
  final GlobalKey formKey;
  final TextEditingController taskTitle;
  final TextEditingController startTime;
  final TextEditingController finishTime;
  final TextEditingController duration;
  final TextEditingController dueDate;
  final TextEditingController notes;
  final OutlineInputBorder _border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.deepOrange));
  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  late FocusNode title;
  late FocusNode startTime;
  late FocusNode finishTime;
  late FocusNode duration;
  late FocusNode dueDate;
  late FocusNode notes;

  @override
  void initState() {
    super.initState();
    title = FocusNode();
    startTime = FocusNode();
    finishTime = FocusNode();
    duration = FocusNode();
    dueDate = FocusNode();
    notes = FocusNode();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      if (widget.startTime.text.isNotEmpty ||
          widget.finishTime.text.isNotEmpty) {
        Provider.of<TaskListManager>(context, listen: false).changeBool(false);
      } else {
        Provider.of<TaskListManager>(context, listen: false).changeBool(true);
      }
      _disableTimeField();
    });
  }

  @override
  void dispose() {
    title.dispose();
    startTime.dispose();
    finishTime.dispose();
    duration.dispose();
    dueDate.dispose();
    notes.dispose();
    super.dispose();
  }

  bool isEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: taskFormWidth(context),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.deepOrange[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Form(
          key: widget.formKey,
          child: Column(
            children: [
              TextFormField(
                  controller: widget.taskTitle,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: "New Task",
                    labelStyle: TextStyle(color: Colors.blueGrey),
                  ),
                  autofocus: true,
                  focusNode: title,
                  onSaved: (val) {
                    title.unfocus();
                  },
                  validator: (value) =>
                      value!.isEmpty ? "Please enter a task" : null),
              ExpansionTile(
                title: const Text("Add details"),
                tilePadding: const EdgeInsets.symmetric(horizontal: 5.0),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 250,
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      color: Colors.deepOrange[100],
                    ),
                    //Target Time Section
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Text(
                          "Target complete time",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: TimeField(
                                clearButton: () {
                                  widget.startTime.clear();
                                  if (widget.startTime.text.isEmpty &&
                                      widget.finishTime.text.isEmpty) {
                                    Provider.of<TaskListManager>(context,
                                            listen: false)
                                        .changeBool(true);
                                  }
                                },
                                controller: widget.startTime,
                                labelText: "Start Time",
                                enabled: isEnabled,
                                focusNode: startTime,
                                requestNode: () => FocusScope.of(context)
                                    .requestFocus(finishTime),
                                validator: (val) => val!.isNotEmpty
                                    ? val.contains(":") == false
                                        ? "Type a time"
                                        : null
                                    : null,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TimeField(
                                clearButton: () {
                                  widget.finishTime.clear();
                                  if (widget.startTime.text.isEmpty &&
                                      widget.finishTime.text.isEmpty) {
                                    Provider.of<TaskListManager>(context,
                                            listen: false)
                                        .changeBool(true);
                                  }
                                },
                                controller: widget.finishTime,
                                labelText: "Finish Time",
                                enabled: isEnabled,
                                focusNode: finishTime,
                                requestNode: () => FocusScope.of(context)
                                    .requestFocus(dueDate),
                                validator: (val) => val!.isNotEmpty
                                    ? val.contains(":") == false
                                        ? "Type a time"
                                        : null
                                    : null,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                height: 20,
                                color: Colors.blueGrey,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 50,
                              child: const Text(
                                "OR",
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                height: 20,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 100,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(4),
                                      ],
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          setState(() {
                                            isEnabled = false;
                                          });
                                        } else {
                                          setState(() {
                                            isEnabled = true;
                                          });
                                        }
                                      },
                                      textAlign: TextAlign.center,
                                      controller: widget.duration,
                                      enabled: Provider.of<TaskListManager>(
                                              context,
                                              listen: true)
                                          .duration,
                                      decoration: InputDecoration(
                                          border: widget._border,
                                          labelText: "Duration",
                                          labelStyle: const TextStyle(
                                              color: Colors.blueGrey),
                                          errorStyle: const TextStyle(
                                            fontSize: 9.0,
                                          ),
                                          errorMaxLines: 2),
                                      keyboardType: TextInputType.number,
                                      focusNode: duration,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (value) {
                                        duration.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(dueDate);
                                      },
                                      validator: (val) => val!.isNotEmpty
                                          ? ((int.tryParse(val)) is! int)
                                              ? "Type an integer"
                                              : (int.parse(val) < 0)
                                                  ? "Cannot be negative"
                                                  : null
                                          : null,
                                    ),
                                  ],
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "mins",
                              style: TextStyle(color: Colors.blueGrey),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  DateField(
                    controller: widget.dueDate,
                    labelText: "Due date",
                    focusNode: dueDate,
                    clearButton: () => widget.dueDate.clear(),
                    requestNode: () =>
                        FocusScope.of(context).requestFocus(notes),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1, //Normal textInputField will be displayed
                    maxLines: 5, // when user presses enter it will adapt to it
                    decoration: InputDecoration(
                      border: widget._border,
                      labelText: "Add Notes",
                      labelStyle: const TextStyle(color: Colors.blueGrey),
                    ),
                    controller: widget.notes,
                    focusNode: notes,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  void _disableTimeField() {
    if (widget.duration.text.isNotEmpty) {
      setState(() {
        isEnabled = false;
      });
    }
  }
}
