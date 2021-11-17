import 'package:flutter/material.dart';
import 'package:to_deer/pages/list_title_page.dart';
import 'package:to_deer/services/auth_service.dart';
import 'package:to_deer/services/database_service.dart';
import 'package:to_deer/services/size_helper.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/widgets/task_list_tile.dart';

class TaskListsPage extends StatelessWidget {
  const TaskListsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var firestore = DatabaseService();
    return StreamBuilder(
      stream: firestore.listsCollection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    context.read<AuthService>().signOut();
                  },
                  icon: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                  ))
            ],
            toolbarHeight: appBarHeight(context),
            backgroundColor: Colors.red,
            shadowColor: Colors.indigo,
            title: SizedBox(
              height: logoHeight(context),
              child: const Image(
                fit: BoxFit.fitWidth,
                color: Colors.white,
                image: AssetImage("images/icons/24.png"),
              ),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(50),
            )),
          ),
          body: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
              color: Colors.blueAccent,
            ),
            child: Column(
              children: [
                // Container(
                //   child: SafeArea(
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                //       children: [
                //         const Text(
                //           "My Lists",
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 40.0,
                //           ),
                //         ),
                //         IconButton(
                //             onPressed: () {
                //               context.read<AuthService>().signOut();
                //             },
                //             icon: const Icon(
                //               Icons.logout_rounded,
                //               color: Colors.white,
                //             ))
                //       ],
                //     ),
                //   ),
                //   height: appBarHeight(context),
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //       color: Colors.orange[700],
                //       borderRadius: const BorderRadius.only(
                //         bottomRight: Radius.circular(50),
                //       )),
                // ),
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var list = snapshot.data.docs[index];
                                  return TaskListTile(
                                    list: list,
                                    index: index,
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider(
                                      height: 20, color: Colors.transparent);
                                },
                              ),
                            ),
                          ],
                        ))),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepOrange[800],
            heroTag: null,
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ListTitlePage()));
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}
