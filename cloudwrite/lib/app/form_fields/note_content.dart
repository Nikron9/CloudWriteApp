import 'package:formz/formz.dart';

enum NoteContentValidationError { empty }

class NoteContent extends FormzInput<String, NoteContentValidationError> {
  const NoteContent.pure() : super.pure('');

  const NoteContent.dirty([String value = '']) : super.dirty(value);

  @override
  NoteContentValidationError validator(String value) {
    return null;
  }
}
