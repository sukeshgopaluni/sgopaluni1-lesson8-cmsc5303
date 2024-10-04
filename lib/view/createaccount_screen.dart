import 'package:flutter/material.dart';
import 'package:lesson6/controller/createaccount_controller.dart';
import 'package:lesson6/model/createaccount_model.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  static const routeName = '/createAccountScreen';

  @override
  State<StatefulWidget> createState() {
    return CreateAccountState();
  }
}

class CreateAccountState extends State<CreateAccountScreen> {
  late CreateAccountModel model;
  late CreateAccountController con;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    model = CreateAccountModel();
    con = CreateAccountController(this);
  }

  void callSetState(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new account'),
      ),
      body: model.inProgress
          ? const Center(child: CircularProgressIndicator())
          : formView(context),
    );
  }

  Widget formView(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(hintText: 'Email address'),
              initialValue: model.email,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              validator: model.validateEmail,
              onSaved: model.saveEmail,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter password',
              ),
              initialValue: model.password,
              autocorrect: false,
              validator: model.validatePassword,
              onSaved: model.savePassword,
              obscureText: !model.showPasswords,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter password to confirm',
              ),
              initialValue: model.password,
              autocorrect: false,
              validator: model.validatePassword,
              onSaved: model.savePasswordConfirm,
              obscureText: !model.showPasswords,
            ),
            Row(
              children: [
                Checkbox(
                  value: model.showPasswords,
                  onChanged: con.showHidePasswords,
                ),
                const Text('Show passwords'),
              ],
            ),
            FilledButton.tonal(
              onPressed: con.createAccount,
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    ));
  }
}