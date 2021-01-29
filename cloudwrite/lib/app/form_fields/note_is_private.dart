import 'package:formz/formz.dart';

enum NoteIsPrivateValidationError { length, empty }

class NoteIsPrivate extends FormzInput<bool, NoteIsPrivateValidationError> {
  const NoteIsPrivate.pure() : super.pure(false);

  const NoteIsPrivate.dirty([bool value = false]) : super.dirty(value);

  @override
  NoteIsPrivateValidationError validator(bool value) {
    return null;
  }
}
