import 'package:formz/formz.dart';

enum PasswordValidationError { length, empty }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');

  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  PasswordValidationError validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    }
    else if ((value.length ?? 0) <= 7) {
      return PasswordValidationError.length;
    } else {
      return null;
    }
  }
}
