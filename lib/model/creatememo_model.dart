import 'package:firebase_auth/firebase_auth.dart';
import 'package:lesson6/model/photomemo.dart';

class CreateMemoModel {
  User user;
  dynamic photo; //mobile (File), web (Uint8List)
  String? photoMimeType; //used by web
  late PhotoMemo tempMemo;
  String? progressMessage;

  CreateMemoModel({required this.user}) {
    tempMemo = PhotoMemo(
      createdBy: '',
      title: '',
      memo: '',
      photoFilename: '',
      photoURL: '',
    );
  }

  void onSavedTitle(String? value) {
    if ( value != null) {
      tempMemo.title = value;
    }
  }

  void onSavedMemo(String? value) {
    if (value != null) {
      tempMemo.memo = value;
    }
  }

  void onSavedSharedWith(String? value) {
    if (value != null) {
      List<String> emailList = 
        value.trim().split(RegExp('(,|;| )+')).map((e) => e.trim()).toList();
      tempMemo.sharedWith = emailList;
    }
  }
}