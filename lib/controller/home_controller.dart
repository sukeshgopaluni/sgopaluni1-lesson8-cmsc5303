// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:lesson6/controller/auth_controller.dart';
import 'package:lesson6/controller/firestore_controller.dart';
import 'package:lesson6/controller/storage_controller.dart';
import 'package:lesson6/model/photomemo.dart';
import 'package:lesson6/view/creatememo_screen.dart';
import 'package:lesson6/view/detailview_screen.dart';
import 'package:lesson6/view/home_screen.dart';
import 'package:lesson6/view/sharedwith_screen.dart';
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
      // create screen cancelled by back button
      return;
    }
    var newMemo = memo as PhotoMemo;
    state.callSetState(() {
      state.model.photoMemoList!.insert(0, newMemo);
    });
  }

  Future<void> loadPhotoMemoList() async {
    try {
      state.model.photoMemoList =
          await getPhotoMemoList(email: state.model.user.email!);
    } catch (e) {
      print('========== loading error: $e');
      if (state.mounted) {
        showSnackbar(
          context: state.context,
          message: 'Failed to load photoMemo list: $e',
          seconds: 10,
        );
      }
    } finally {
      state.callSetState(() {});
    }
  }

  void onTap(int index) async {
    if (state.model.deleteIndex != null) {
      state.callSetState(() {
        state.model.deleteIndex = null; // cancel selection
      });
      return;
    }
    final updated = await Navigator.pushNamed(
      state.context,
      DetailViewScreen.routeName,
      arguments: state.model.photoMemoList![index],
    );

    if (updated == null) return;

    //update home screen
    state.callSetState(() {
      state.model.photoMemoList!.sort((a, b) {
        if (a.timestamp!.isBefore(b.timestamp!)) {
          return 1;
        } else if (a.timestamp!.isAfter(b.timestamp!)) {
          return -1;
        } else {
          return 0;
        }
      });
    });
  }

  void sharedWith() {
    Navigator.popAndPushNamed(
      state.context,
      SharedWithScreen.routeName,
    );
  }

  void onLongPress(int index) {
    state.callSetState(() {
      if (state.model.deleteIndex == null || state.model.deleteIndex != index) {
        state.model.deleteIndex = index;
      } else {
        state.model.deleteIndex = null; // cancel selection
      }
    });
  }

  Future<void> delete() async {
    PhotoMemo p = state.model.photoMemoList![state.model.deleteIndex!];
    state.callSetState(() {
      state.model.deleteInProgress = true;
    });
    try {
      await deleteDoc(docId: p.docId!);
      await deleteFile(filename: p.photoFilename);
      state.callSetState(() {
        state.model.photoMemoList!.removeAt(state.model.deleteIndex!);
        state.model.deleteIndex = null;
        state.model.deleteInProgress = false;
      });
    } catch (e) {
      state.callSetState(() {
        state.model.deleteIndex = null;
        state.model.deleteInProgress = false;
      });
      print('========= delete failed: $e');
      if (state.mounted) {
        showSnackbar(
          context: state.context,
          message: 'Delete failed: $e',
        );
      }
    }
  }
}