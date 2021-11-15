import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/models/task_model.dart';
import 'package:to_deer/utils/task_list_manager.dart';
import 'package:to_deer/widgets/task_form.dart';
import 'package:to_deer/widgets/bottom_app_bar.dart';

class AddListPage extends StatelessWidget {
  AddListPage({Key? key}) : super(key: key);
  final taskTitle = TextEditingController();
  final startTime = TextEditingController();
  final finishTime = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final duration = TextEditingController();
  final dueDate = TextEditingController();
  final notes = TextEditingController();
  void _clearForm() {
    _formKey.currentState!.reset();
    // Does not clear date and times.
  }

  @override
  Widget build(BuildContext context) {
    var _taskListManager = Provider.of<TaskListManager>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Text(
              "${_taskListManager.listTitle}",
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
                }
              },
              child: const Text("Add"),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              height: 300,
              child: Consumer<TaskListManager>(
                  builder: (context, taskListManager, child) =>
                      ListView.separated(
                        itemCount: taskListManager.listLength,
                        itemBuilder: (BuildContext context, int index) {
                          var task = taskListManager.taskList[index];
                          return ListTile(
                            tileColor: Colors.blueGrey[100],
                            trailing: IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                ),
                                onPressed: () =>
                                    taskListManager.removeTask(task)),
                            title: Row(
                              children: [
                                Text(
                                  "${index + 1}. ",
                                  style:
                                      const TextStyle(color: Colors.blueAccent),
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
                      )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ListBottomBar(),
    );
  }
}
