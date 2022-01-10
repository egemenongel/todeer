import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/core/components/task_form/task_form.dart';
import 'package:to_deer/features/models/list.dart';
import 'package:to_deer/features/models/task.dart';
import 'package:to_deer/features/services/database_service.dart';
import 'package:to_deer/features/utils/form_manager.dart';
import 'package:to_deer/features/utils/task_list_manager.dart';

class AddTasksView extends StatefulWidget {
  const AddTasksView({Key? key, required this.list}) : super(key: key);
  final ListModel list;
  @override
  State<AddTasksView> createState() => _AddTasksViewState();
}

class _AddTasksViewState extends State<AddTasksView> {
  final databaseService = DatabaseService();
  final taskTitle = TextEditingController();
  final startTime = TextEditingController();
  final finishTime = TextEditingController();
  final duration = TextEditingController();
  final dueDate = TextEditingController();
  final notes = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _clearForm() {
    _formKey.currentState!.reset();
    taskTitle.clear();
    startTime.clear();
    finishTime.clear();
    duration.clear();
    dueDate.clear();
    notes.clear();
  }

  @override
  void dispose() {
    taskTitle.dispose();
    startTime.dispose();
    finishTime.dispose();
    duration.dispose();
    dueDate.dispose();
    notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _taskListManager =
        Provider.of<TaskListManager>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            Text(
              widget.list.title,
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.blueGrey[700],
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            TaskForm(
              formKey: _formKey,
              taskTitle: taskTitle,
              startTime: startTime,
              finishTime: finishTime,
              duration: duration,
              dueDate: dueDate,
              notes: notes,
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  TaskModel task = TaskModel(
                    title: taskTitle.text,
                    startTime: startTime.text,
                    finishTime: finishTime.text,
                    duration: duration.text,
                    dueDate: dueDate.text,
                    isCompleted: false,
                    notes: notes.text,
                  );
                  _taskListManager.addTask(task);
                  _clearForm();
                  FocusScope.of(context).unfocus();
                  Provider.of<FormManager>(context, listen: false)
                      .changeDurationBool(true);
                  Provider.of<FormManager>(context, listen: false)
                      .changeTimeBool(true);
                }
              },
              child: const Text("Add"),
            ),
            buildList(context),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomBar(context, _taskListManager),
    );
  }

  buildList(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      height: 300,
      child: Consumer<TaskListManager>(builder: (_, taskListManager, __) {
        if (taskListManager.taskList.isNotEmpty) {
          return ListView.separated(
            itemCount: taskListManager.listLength,
            itemBuilder: (BuildContext context, int index) {
              var task = taskListManager.taskList[index];
              return ListTile(
                tileColor: Colors.blueGrey[100],
                trailing: IconButton(
                    icon: const Icon(
                      Icons.remove_circle,
                    ),
                    onPressed: () => taskListManager.removeTask(task)),
                title: Row(
                  children: [
                    Text(
                      "${index + 1}. ",
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                    Text(
                      task.title,
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 0,
                thickness: 2.0,
              );
            },
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
          );
        }
      }),
    );
  }

  buildBottomBar(BuildContext context, TaskListManager taskListManager) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
                onPressed: () =>
                    context.read<TaskListManager>().clearCurrentList(),
                child: const Text("Clear List")),
          ),
          const SizedBox(
            height: 30,
            child: VerticalDivider(color: Colors.grey),
            width: 0,
          ),
          Expanded(
              child: TextButton(
                  style: const ButtonStyle(),
                  onPressed: () {
                    databaseService.addList(
                      widget.list,
                      taskListManager,
                    );
                    Navigator.popUntil(context, (route) => route.isFirst);
                    taskListManager.clearCurrentList();
                  },
                  child: const Text("Submit")))
        ],
      ),
    );
  }
}
