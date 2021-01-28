import 'package:equatable/equatable.dart';

abstract class NotesEvent extends Equatable {

}

class Fetch extends NotesEvent {
  @override
  List<Object> get props => [];
}