import 'package:lesson6/controller/auth_controller.dart';
import 'package:lesson6/view/home_screen.dart';

class HomeController {
  HomeState state;
  HomeController(this.state);

  Future<void> signOut() async {
    await firebaseSignOut();
  }
}