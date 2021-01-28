import 'package:formz/formz.dart';

enum UsernameValidationError { length, empty }

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');

  const Username.dirty([String value = '']) : super.dirty(value);

  @override
  UsernameValidationError validator(String value) {
    if (value.isEmpty) {
      return UsernameValidationError.empty;
    } else if ((value.length ?? 0) < 3) {
      return UsernameValidationError.length;
    } else {
      return null;
    }
  }
}
