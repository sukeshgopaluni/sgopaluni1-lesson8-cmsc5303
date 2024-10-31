import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

const photoFolder = 'photo_files';

Future<(String, String)> uploadPhotoFile({
  required dynamic photo,
  String? photoMimeType,
  String? filename,
  required String uid,
  required Function listener,
}) async {
  filename ??= '$photoFolder/$uid/${const Uuid().v1()}';
  UploadTask task = kIsWeb
      ? FirebaseStorage.instance
          .ref(filename)
          .putData(photo, SettableMetadata(contentType: photoMimeType))
      : FirebaseStorage.instance
          .ref(filename)
          .putFile(photo, SettableMetadata(contentType: photoMimeType));

  task.snapshotEvents.listen((TaskSnapshot event) {
    int progress = (event.bytesTransferred / event.totalBytes * 100).toInt();
    listener(progress);
  });

  TaskSnapshot snapshot = await task;
  String downloadURL = await snapshot.ref.getDownloadURL();
  return (filename, downloadURL);
}