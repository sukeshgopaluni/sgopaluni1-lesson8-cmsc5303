// ignore_for_file: avoid_print

import 'package:lesson6/controller/firestore_controller.dart';
import 'package:lesson6/view/sharedwith_screen.dart';

class SharedWithController {
  SharedWithState state;
  SharedWithController(this.state);

  Future<void> loadSharedWithList() async {
    try {
      state.model.sharedWithList =
          await getSharedWithList(email: state.model.user.email!);
      state.callSetState((){
        state.model.loadingErrorMessage = null;
      });
      print('shared with: ${state.model.sharedWithList?.length}}');
    } catch (e) {
      print('=========== failed to get sharedwith list $e');
      state.callSetState(() {
        state.model.loadingErrorMessage = 'Internal loading error. $e';
      });
    }
  }
}