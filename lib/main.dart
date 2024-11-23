import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lesson6/model/photomemo.dart';
import 'package:lesson6/view/createaccount_screen.dart';
import 'package:lesson6/view/creatememo_screen.dart';
import 'package:lesson6/view/detailview_screen.dart';
import 'package:lesson6/view/error_screen.dart';
import 'package:lesson6/view/sharedwith_screen.dart';
import 'package:lesson6/view/startdispatcher.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FirebaseTemplateApp());
}

class FirebaseTemplateApp extends StatelessWidget {
  const FirebaseTemplateApp({super.key});

  @override
  Widget build(Object context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      initialRoute: StartDispatcher.routeName,
      routes: {
        StartDispatcher.routeName: (context) => const StartDispatcher(),
        CreateAccountScreen.routeName: (context) => const CreateAccountScreen(),
        CreateMemoScreen.routeName: (context) => const CreateMemoScreen(),
        SharedWithScreen.routeName: (context) => const SharedWithScreen(),
        DetailViewScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args != null && args is PhotoMemo) {
            return DetailViewScreen(
              photoMemo: args,
            );
          } else {
            return const ErrorScreen('args is not PhotoMemo');
          }
        },
      },
    );
  }
}