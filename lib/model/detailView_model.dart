import 'package:firebase_auth/firebase_auth.dart';
import 'package:lesson6/model/photomemo.dart';

class DetailViewModel {
  final User user;
  final PhotoMemo photoMemo;
  bool editMode = false;
  late PhotoMemo tempMemo;
  dynamic photo; // mobile (file) web (Unit8List)
  String? photoMimeType;
  String? progressMessage;

  DetailViewModel({
    required this.user,
    required this.photoMemo,
  }) {
    tempMemo = photoMemo.clone();
  }

  void saveTitle(String? value) {
    if (value != null) tempMemo.title = value.trim();
  }

  void saveMemo(String? value) {
    if (value != null) tempMemo.memo = value.trim();
  }

  void saveSharedWith(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      List<String> emails = value.trim().split(RegExp(r'[,;\s]+'));
      tempMemo.sharedWith = emails;
    }
  }
}