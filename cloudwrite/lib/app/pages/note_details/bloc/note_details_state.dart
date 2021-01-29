import 'package:cloudwrite/app/form_fields/note_content.dart';
import 'package:cloudwrite/app/form_fields/note_is_private.dart';
import 'package:cloudwrite/app/form_fields/note_title.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

enum NoteDetailsMode { Read, Edit, Create }

class NoteDetailsState extends Equatable {
  const NoteDetailsState(
      {this.formState = FormzStatus.pure,
      this.mode = NoteDetailsMode.Edit,
      this.title = const NoteTitle.pure(),
      this.content = const NoteContent.pure(),
      this.isPrivate = const NoteIsPrivate.pure()});

  get isFormValid => title.error == null && content.error == null;
  final FormzStatus formState;
  final NoteDetailsMode mode;
  final NoteTitle title;
  final NoteContent content;
  final NoteIsPrivate isPrivate;

  NoteDetailsState copyWith(
      {FormzStatus status,
      NoteDetailsState mode,
      NoteTitle title,
      NoteContent content,
      NoteIsPrivate isPrivate}) {
    return NoteDetailsState(
        formState: status ?? this.formState,
        mode: mode ?? this.mode,
        title: title ?? this.title,
        content: content ?? this.content,
        isPrivate: isPrivate ?? this.isPrivate);
  }

  @override
  List<Object> get props => [formState, mode, title, content, isPrivate];
}
