import 'package:flutter/material.dart';
import 'package:to_deer/pages/add_list/add_list_page.dart';
import 'package:to_deer/pages/home/app_bar.dart';
import 'package:to_deer/pages/home/drawer.dart';
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
        backgroundColor: const Color(0xffF31715),
        heroTag: null,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddListPage()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
