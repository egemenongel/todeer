import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/models/list.dart';
import 'package:to_deer/services/database_service.dart';
import 'package:to_deer/utils/task_list_manager.dart';

class ListBottomBar extends StatelessWidget {
  const ListBottomBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var _taskListManager = Provider.of<TaskListManager>(context, listen: false);
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
                    ListModel newList = ListModel(
                        title: _taskListManager.listTitle!,
                        dueDate: _taskListManager.listDueDate);
                    var firestore = DatabaseService();
                    firestore.addList(
                      newList,
                      _taskListManager,
                    );
                    Navigator.popUntil(context, (route) => route.isFirst);
                    _taskListManager.clearCurrentList();
                  },
                  child: const Text("Submit")))
        ],
      ),
    );
  }
}
