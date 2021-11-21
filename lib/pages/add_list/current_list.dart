import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/utils/task_list_manager.dart';

class CurrentList extends StatelessWidget {
  const CurrentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      height: 300,
      child:
          Consumer<TaskListManager>(builder: (context, taskListManager, child) {
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
}
