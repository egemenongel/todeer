import 'package:flutter/material.dart';
import 'package:to_deer/models/list.dart';
import 'package:to_deer/pages/home/task_list_tile.dart';
import 'package:to_deer/services/database_service.dart';

class Lists extends StatelessWidget {
  const Lists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var database = DatabaseService();
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
        color: Colors.blueAccent,
      ),
      child: Column(
        children: [
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      StreamBuilder(
                        stream: database.listsCollection.snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.red,
                              ),
                            );
                          }
                          return Expanded(
                            child: snapshot.data.docs.length == 0
                                ? const Center(
                                    child: Text(
                                    "You don't have any list. Add a new list to start",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ))
                                : ListView.separated(
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var list = snapshot.data.docs[index];
                                      ListModel listModel = ListModel(
                                          title: list["title"],
                                          dueDate: list["dueDate"]);
                                      return TaskListTile(
                                        listModel: listModel,
                                        list: list,
                                        index: index,
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const Divider(
                                          height: 20,
                                          color: Colors.transparent);
                                    },
                                  ),
                          );
                        },
                      ),
                    ],
                  ))),
        ],
      ),
    );
  }
}
