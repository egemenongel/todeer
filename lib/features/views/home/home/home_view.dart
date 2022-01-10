import 'package:flutter/material.dart';
import 'package:to_deer/core/extension/context_extension.dart';
import 'package:to_deer/features/models/list.dart';
import 'package:to_deer/features/services/database_service.dart';

import 'package:to_deer/core/components/app_bar/app_bar.dart';
import 'package:to_deer/core/components/drawer/drawer.dart';
import 'package:to_deer/core/components/task_list_tile/task_list_tile.dart';
import 'package:to_deer/features/views/home/add_list/add_list_view.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final database = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      extendBodyBehindAppBar: true,
      endDrawer: const HomeDrawer(),
      appBar: HomeAppBar(
        scaffoldKey: _key,
        preferredSize: context.appBarSize,
      ),
      body: buildLists(context),
      floatingActionButton: buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  buildLists(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
        // color: Color(0xffF7766A),
        gradient: LinearGradient(
          colors: [
            Color(0xffCA6357),
            Color(0xffF7766A),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
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
                                ? Center(
                                    child: Text(
                                    "You don't have any list. Add a new list to start",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: context.colors.onSecondary,
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

  FloatingActionButton buildFAB(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      child: const Icon(Icons.add),
      tooltip: "New list",
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddListView()),
      ),
    );
  }
}
