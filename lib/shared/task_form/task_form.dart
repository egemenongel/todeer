import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/services/size_helper.dart';
import 'package:to_deer/shared/constants.dart';
import 'package:to_deer/utils/form_manager.dart';
import 'package:to_deer/shared/task_form/date_field.dart';
import 'package:to_deer/shared/task_form/time_field.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({
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
      _setTimeField();
      _setDurationField();
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
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      color: Colors.deepOrange[100],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Text(
                          "Target completion time",
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
                                    Provider.of<FormManager>(context,
                                            listen: false)
                                        .changeDurationBool(true);
                                  }
                                },
                                controller: widget.startTime,
                                labelText: "Start Time",
                                enabled: Provider.of<FormManager>(context,
                                        listen: true)
                                    .time,
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
                                    Provider.of<FormManager>(context,
                                            listen: false)
                                        .changeDurationBool(true);
                                  }
                                },
                                controller: widget.finishTime,
                                labelText: "Finish Time",
                                enabled: Provider.of<FormManager>(context,
                                        listen: true)
                                    .time,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: displayWidth(context) / 6,
                            ),
                            Expanded(
                              child: TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    Provider.of<FormManager>(context,
                                            listen: false)
                                        .changeTimeBool(false);
                                  } else {
                                    Provider.of<FormManager>(context,
                                            listen: false)
                                        .changeTimeBool(true);
                                  }
                                },
                                textAlign: TextAlign.center,
                                controller: widget.duration,
                                enabled: Provider.of<FormManager>(context,
                                        listen: true)
                                    .duration,
                                decoration: InputDecoration(
                                    border: taskFormBorder(),
                                    enabledBorder:
                                        widget.duration.text.isNotEmpty
                                            ? taskFormBorder()
                                            : null,
                                    labelText: "Duration",
                                    errorStyle: const TextStyle(
                                      fontSize: 9.0,
                                    ),
                                    errorMaxLines: 2),
                                keyboardType: TextInputType.number,
                                focusNode: duration,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (value) {
                                  duration.unfocus();
                                  FocusScope.of(context).requestFocus(dueDate);
                                },
                                validator: (val) => val!.isNotEmpty
                                    ? ((int.tryParse(val)) is! int)
                                        ? "Type an integer"
                                        : (int.parse(val) < 0)
                                            ? "Cannot be negative"
                                            : null
                                    : null,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "mins",
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(
                              width: displayWidth(context) / 6,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
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
                      border: taskFormBorder(),
                      enabledBorder: widget.notes.text.isNotEmpty
                          ? taskFormBorder()
                          : null,
                      labelText: "Add Notes",
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

  void _setTimeField() {
    if (widget.duration.text.isNotEmpty) {
      Provider.of<FormManager>(context, listen: false).changeTimeBool(false);
    } else {
      Provider.of<FormManager>(context, listen: false).changeTimeBool(true);
    }
  }

  void _setDurationField() {
    if (widget.startTime.text.isNotEmpty || widget.finishTime.text.isNotEmpty) {
      Provider.of<FormManager>(context, listen: false)
          .changeDurationBool(false);
    } else {
      Provider.of<FormManager>(context, listen: false).changeDurationBool(true);
    }
  }
}
