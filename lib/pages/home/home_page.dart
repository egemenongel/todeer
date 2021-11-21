import 'package:flutter/material.dart';
import 'package:to_deer/pages/add_list/list_title_page.dart';
import 'package:to_deer/pages/home/home_app_bar.dart';
import 'package:to_deer/pages/home/home_drawer.dart';
import 'package:to_deer/pages/home/lists.dart';
import 'package:to_deer/services/size_helper.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      extendBodyBehindAppBar: true,
      endDrawer: const HomeDrawer(),
      appBar: HomeAppBar(
        scaffoldKey: _key,
        preferredSize: appBarSize(context),
      ),
      body: const Lists(),
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
  }
}
