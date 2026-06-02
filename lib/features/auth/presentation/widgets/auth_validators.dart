class AuthValidators {
  AuthValidators._();

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (email.isEmpty) return 'أدخل البريد الإلكتروني';
    if (!regex.hasMatch(email)) return 'البريد الإلكتروني غير صحيح';

    return null;
  }

  static String? password(String? value) {
    final password = value ?? '';

    if (password.isEmpty) return 'أدخل كلمة المرور';
    if (password.length < 6) return 'كلمة المرور يجب ألا تقل عن 6 أحرف';

    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final validation = AuthValidators.password(value);
    if (validation != null) return validation;

    if (value != password) return 'كلمتا المرور غير متطابقتين';

    return null;
  }
}
