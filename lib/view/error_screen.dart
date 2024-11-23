import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen(this.error, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internal Error'),
      ),
      body: Text(
        'Restart the app, please!\n$error',
        style: const TextStyle(
          color: Colors.red,
          fontSize: 18.0,
        ),
      ),
    );
  }
}