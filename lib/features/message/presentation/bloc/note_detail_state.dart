import 'package:equatable/equatable.dart';

// States
abstract class NoteDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoteDetailInitial extends NoteDetailState {}

class NoteDetailLoading extends NoteDetailState {}

class NoteDetailLoaded extends NoteDetailState {
  final String message;
  final String? imageUrl;

  NoteDetailLoaded({required this.message, this.imageUrl});

  @override
  List<Object?> get props => [message, imageUrl];
}

class NoteDetailError extends NoteDetailState {
  final String message;

  NoteDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
