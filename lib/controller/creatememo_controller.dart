// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:lesson6/controller/firestore_controller.dart';
import 'package:lesson6/controller/get_photo.dart';
import 'package:lesson6/controller/storage_controller.dart';
import 'package:lesson6/model/photomemo.dart';
import 'package:lesson6/view/creatememo_screen.dart';
import 'package:lesson6/view/show_snackbar.dart';
//import 'package:lesson6/view/show_snackbar.dart';

class CreateMemoController {
  CreateMemoState state;

  CreateMemoController(this.state);

  getPhoto(CameraOrGallery source) async {
    try {
      var (photo, mimeType) = await getPhotoFromDevice(source);
      if (photo == null) return;
      state.callSetState(() {
        state.model.photo = photo;
        state.model.photoMimeType = mimeType;
      });
    } catch (e) {
      print('========= failed to get photo: $e');
      showSnackbar(
        context: state.context,
        message: 'Failed to get photo: $e',
      );
    }
  }

  Future<void> save() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null) return;
    if (!(currentState.validate())) return;
    if (state.model.photo == null) {
      showSnackbar(
        context: state.context,
        message: 'Photo not selected',
        seconds: 10,
      );
      return;
    }

    currentState.save();

    try {
      var (filename, downloadURL) = await uploadPhotoFile(
        photo: state.model.photo,
        uid: state.model.user.uid,
        photoMimeType: state.model.photoMimeType,
        listener: (int progress) {
          state.callSetState(() {
            if (progress == 100) {
              state.model.progressMessage = null;
            } else {
              state.model.progressMessage = 'Uploading: $progress %';
            }
          });
        },
      );
      state.callSetState(
          () => state.model.progressMessage = 'Saving PhotoMemo ...');
      state.model.tempMemo.photoFilename = filename;
      state.model.tempMemo.photoURL = downloadURL;
      state.model.tempMemo.createdBy = state.model.user.email!;
      state.model.tempMemo.timestamp = DateTime.now();
      String docId = await addPhotoMemo(photoMemo: state.model.tempMemo);
      state.model.tempMemo.docId = docId;
      if (state.mounted) {
        Navigator.of(state.context).pop(state.model.tempMemo);
      }
    } catch (e) {
      state.callSetState(() => state.model.progressMessage = null);
      print('****** Save photomemo error: $e');
      if (state.mounted) {
        showSnackbar(
          context: state.context,
          message: 'Save photomemo error: $e',
          seconds: 10,
        );
      }
    }
  }
}