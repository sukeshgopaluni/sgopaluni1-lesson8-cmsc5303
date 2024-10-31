// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:lesson6/controller/auth_controller.dart';
import 'package:lesson6/controller/firestore_controller.dart';
import 'package:lesson6/model/photomemo.dart';
import 'package:lesson6/view/creatememo_screen.dart';
import 'package:lesson6/view/home_screen.dart';
import 'package:lesson6/view/show_snackbar.dart';

class HomeController {
  HomeState state;
  HomeController(this.state);

  Future<void> signOut() async {
    await firebaseSignOut();
  }

  Future<void> gotoCreateMemo() async {
    final memo =
        await Navigator.pushNamed(state.context, CreateMemoScreen.routeName);
    if (memo == null) {
      //create screen canceled by BACK button
      return;
    }
    var newMemo = memo as PhotoMemo;
    state.callSetState((){
       state.model.photoMemoList!.insert(0, newMemo);
    });
  }

  Future<void> loadPhotoMemoList() async {
    try {
      state.model.photoMemoList =
          await getPhotoMemoList(email: state.model.user.email!);
    } catch (e) {
      print('===== loading error: $e');
      if (state.mounted) {
        showSnackbar(
          context: state.context,
          message: 'Failed to load PhotoMemo list: $e',
          seconds: 10,
        );
      }
    } finally {
      state.callSetState(() {});
    }
  }
}