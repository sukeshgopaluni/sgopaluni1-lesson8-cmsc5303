class SignInModel {
  String? email;
  String? password;
  bool inProgress = false;


  String? validateEmail(String? value){
    if (value == null || value.isEmpty) {
      return 'No email provided';
    } else if (!(value.contains('@') && value.contains('.'))) {
      return 'Invalid email address';
    } else {
      return null;
    }
  }

  String? validatePassword (String? value) {
    if (value == null || value.isEmpty) {
      return 'No password provided';
    } else if (value.length < 6) {
      return 'min chars is 6';
    } else {
      return null;
    }
  }

  void saveEmail(String? value) {
    if  (value != null) email = value;
  }

  void savePassword(String? value) {
    if (value != null) password = value;
  }
}