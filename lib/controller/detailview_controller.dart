// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lesson6/controller/firestore_controller.dart';
import 'package:lesson6/controller/get_photo.dart';
import 'package:lesson6/controller/storage_controller.dart';
import 'package:lesson6/model/photomemo.dart';
import 'package:lesson6/view/detailview_screen.dart';
//import 'package:lesson6/view/show_snackbar.dart';
import 'package:lesson6/view/show_snackbar.dart';

class DetailViewController {
  DetailViewState state;
  DetailViewController(this.state);

  void edit() {
    state.callSetState(() {
      state.model.editMode = true;
    });
  }

  void setUpdatedFields(Map<String, dynamic> fieldsToUpdate) {
    if (state.model.tempMemo.title != state.model.photoMemo.title) {
      fieldsToUpdate[DocKeyPhotoMemo.title.name] = state.model.tempMemo.title;
    }
    if (state.model.tempMemo.memo != state.model.photoMemo.memo) {
      fieldsToUpdate[DocKeyPhotoMemo.memo.name] = state.model.tempMemo.memo;
    }
    if (!listEquals(
        state.model.tempMemo.sharedWith, state.model.photoMemo.sharedWith)) {
      fieldsToUpdate[DocKeyPhotoMemo.sharedWith.name] =
          state.model.tempMemo.sharedWith;
    }
    if (state.model.tempMemo.photoFilename !=
        state.model.photoMemo.photoFilename) {
      fieldsToUpdate[DocKeyPhotoMemo.photoFilename.name] =
          state.model.tempMemo.photoFilename;
    }
    if (state.model.tempMemo.photoURL != state.model.photoMemo.photoURL) {
      fieldsToUpdate[DocKeyPhotoMemo.photoURL.name] =
          state.model.tempMemo.photoURL;
    }
  }

  void update() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null) return;
    if (!currentState.validate()) return;
    currentState.save();

    Map<String, dynamic> fieldsToUpdate = {};
    String? originalPhotoFilename;

    try {
      if (state.model.photo != null) {
        var (photoFilename, photoURL) = await uploadPhotoFile(
          photo: state.model.photo,
          photoMimeType: state.model.photoMimeType,
          uid: state.model.user.uid,
          listener: (int progress) {
            state.callSetState(() {
              state.model.progressMessage =
                  progress == 100 ? null : 'Uploading: $progress %';
            });
          },
        );
        state.model.tempMemo.photoFilename = photoFilename;
        state.model.tempMemo.photoURL = photoURL;
      }
      setUpdatedFields(fieldsToUpdate);

      if (fieldsToUpdate.isEmpty) {
        state.callSetState(() {
          state.model.progressMessage = null;
          state.model.editMode = false;
        });
        showSnackbar(
          context: state.context,
          message: 'No changed have been made for update',
        );
      } else {
        // update the doc
        state.model.tempMemo.timestamp = DateTime.now();
        fieldsToUpdate[DocKeyPhotoMemo.timestamp.name] =
            state.model.tempMemo.timestamp;
        state.callSetState(() {
          state.model.progressMessage = 'Updating PhotoMemo Doc...';
        });
        await updatePhotoMemo(
          docId: state.model.tempMemo.docId!,
          update: fieldsToUpdate,
        );

        if (fieldsToUpdate[DocKeyPhotoMemo.photoFilename.name] != null) {
          originalPhotoFilename = state.model.photoMemo.photoFilename;
        }

        state.model.photoMemo.copyFrom(state.model.tempMemo);
        state.model.editMode = false;
        state.model.progressMessage = null;
      }
    } catch (e) {
      state.callSetState(() {
        state.model.progressMessage = null;
      });
      if (fieldsToUpdate[DocKeyPhotoMemo.photoFilename.name] != null) {
        // upload new image success, failed to update firestore
        await deleteFile(filename: state.model.tempMemo.photoFilename);
      }
      print('========== $e');
      if (state.mounted) {
        showSnackbar(
          context: state.context,
          message: 'Failed to update: $e',
        );
      }
      return;
    }

    // all changes including photofile done
    // delete the original image file
    if (originalPhotoFilename != null) {
      try {
        await deleteFile(filename: originalPhotoFilename);
      } catch (e) {
        print('========== $e');
        if (state.mounted) {
          showSnackbar(
            context: state.context,
            message: 'Failed to delete original',
          );
        }
      }
    }

    if (state.mounted) {
      Navigator.of(state.context).pop(true);
    }
  }

  Future<void> getPhoto(CameraOrGallery source) async {
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
}