import 'package:formz/formz.dart';

enum NoteTitleValidationError { empty }

class NoteTitle extends FormzInput<String, NoteTitleValidationError> {
  const NoteTitle.pure() : super.pure('');

  const NoteTitle.dirty([String value = '']) : super.dirty(value);

  @override
  NoteTitleValidationError validator(String value) {
    if (value?.isEmpty == true) {
      return NoteTitleValidationError.empty;
    } else {
      return null;
    }
  }
}
