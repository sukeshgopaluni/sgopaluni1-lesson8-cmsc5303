import 'package:firebase_auth/firebase_auth.dart';
import 'package:lesson6/model/photomemo.dart';

class SharedWithModel {
  List<PhotoMemo>? sharedWithList;
  final User user;
  String? loadingErrorMessage;

  SharedWithModel({required this.user});
}