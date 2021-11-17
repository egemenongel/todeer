import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_deer/pages/list_title_page.dart';
import 'package:to_deer/services/auth_service.dart';
import 'package:to_deer/services/database_service.dart';
import 'package:to_deer/services/size_helper.dart';
import 'package:provider/provider.dart';
import 'package:to_deer/widgets/task_list_tile.dart';

class TaskListsPage extends StatelessWidget {
  TaskListsPage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _key = GlobalKey();
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
          key: _key,
          extendBodyBehindAppBar: true,
          endDrawer: SizedBox(
            width: displayWidth(context) / 3,
            child: Drawer(
                child: Container(
              color: Colors.indigoAccent,
              child: ListView(
                children: [
                  const ListTile(
                    title: CircleAvatar(
                      child: Icon(
                        Icons.person,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "${FirebaseAuth.instance.currentUser!.email}",
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ListTile(
                    title: IconButton(
                        onPressed: () => context.read<AuthService>().signOut(),
                        icon: const Icon(
                          Icons.power_settings_new,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
            )),
          ),
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    _key.currentState!.openEndDrawer();
                  },
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                  )),
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
