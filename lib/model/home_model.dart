import 'package:firebase_auth/firebase_auth.dart';
import 'package:lesson6/model/photomemo.dart';

class HomeModel {
  User user;
  List<PhotoMemo>? photoMemoList;
  HomeModel(this.user);
}