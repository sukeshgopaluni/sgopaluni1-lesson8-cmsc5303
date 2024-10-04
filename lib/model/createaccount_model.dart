class CreateAccountModel {
  String? email;
  String? password;
  String? passwordConfirm;
  bool showPasswords = false;
  bool inProgress = false;

  String? validateEmail(String? value) {
    if (value == null) return 'Email not entered';
    String email = value.trim();
    if ( !(email.contains('@') && email.contains('.'))) {
      return 'Invalid email format';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    if (value == null) return 'Password not entered';
    String password = value.trim();
    if (password.length < 6) {
      return 'Password too short. Min 6 chars';
    } else {
      return null;
    }
  }

  void saveEmail(String? value) {
    email = value?.trim();
  }

  void savePassword(String? value) {
    password = value?.trim();
  }

  void savePasswordConfirm(String? value) {
    passwordConfirm = value?.trim();
  }
}