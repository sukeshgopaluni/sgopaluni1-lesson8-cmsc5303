import 'package:flutter/material.dart';
import 'package:lesson6/controller/auth_controller.dart';
import 'package:lesson6/controller/home_controller.dart';
import 'package:lesson6/model/home_model.dart';
import 'package:lesson6/model/photomemo.dart';
import 'package:lesson6/view/web_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeScreen> {
  late HomeController con;
  late HomeModel model;

  @override
  void initState() {
    super.initState();
    con = HomeController(this);
    model = HomeModel(currentUser!);
    con.loadPhotoMemoList();
  }

  void callSetState(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          if (model.deleteIndex != null)
            IconButton(
              onPressed: con.delete,
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      // ignore: deprecated_member_use
      body: bodyView(),
      // WillPopScope(
      //   onWillPop: () => Future.value(false), // disable systemback button
      //   child: Text(model.user.email!),
      // ),
      drawer: drawerView(context),
      floatingActionButton: FloatingActionButton(
        onPressed: con.gotoCreateMemo,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget bodyView() {
    if (model.photoMemoList == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return showPhotoMemoList();
    }
  }

  Widget showPhotoMemoList() {
    if (model.photoMemoList!.isEmpty) {
      return Center(
        child: Text(
          'No PhotoMemo Found!',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    } else {
      return ListView.builder(
        itemCount: model.photoMemoList!.length,
        itemBuilder: (BuildContext context, int index) {
          PhotoMemo photoMemo = model.photoMemoList![index];
          return ListTile(
            selected: model.deleteIndex == index,
            selectedColor: Colors.redAccent[100],
            leading: model.deleteInProgress && model.deleteIndex == index
                ? const CircularProgressIndicator()
                : WebImage(
                    url: photoMemo.photoURL,
                  ),
            trailing: const Icon(Icons.arrow_right),
            title: Text(photoMemo.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  photoMemo.memo.length >= 40
                      ? '${photoMemo.memo.substring(0, 40)}...'
                      : photoMemo.memo,
                ),
                Text('Created By: ${photoMemo.createdBy}'),
                Text('SharedWith: ${photoMemo.sharedWith}'),
                Text('Timestamp: ${photoMemo.timestamp}'),
              ],
            ),
            onTap: () => con.onTap(index),
            onLongPress: () => con.onLongPress(index),
          );
        },
      );
    }
  }

  Widget drawerView(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('No profile'),
            accountEmail: Text(model.user.email!),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Shared With'),
            onTap: con.sharedWith,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: con.signOut,
          ),
        ],
      ),
    );
  }
}