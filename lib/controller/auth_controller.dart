import 'package:firebase_auth/firebase_auth.dart';

User? currentUser;

Future<User?> firebaseSignIn(
    {required String email, required String password}) async {
  UserCredential credential = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: password);
  return credential.user;
}

Future<void> firebaseSignOut() async {
  await FirebaseAuth.instance.signOut();
}

Future<void> firebaseCreateAccount({
  required String email,
  required String password,
}) async {
  await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
}