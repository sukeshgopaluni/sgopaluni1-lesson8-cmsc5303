import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesson6/model/photomemo.dart';
import 'package:mime/mime.dart';

Future<(dynamic, String?)> getPhotoFromDevice(CameraOrGallery source) async {
  var imageSource = source == CameraOrGallery.camera
      ? ImageSource.camera : ImageSource.gallery;
  XFile? image = await ImagePicker().pickImage(source: imageSource);
  if (image == null) return (null, null); // cancelled at camera or gallery
  dynamic photo;
  if (kIsWeb) { // Unit8List
    photo = await image.readAsBytes();
    return (photo ,image.mimeType);
  } else {
    photo = File(image.path);
    var mimeType = lookupMimeType(image.path);
    return (photo, mimeType);
  }
}