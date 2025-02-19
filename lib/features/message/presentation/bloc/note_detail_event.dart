import 'package:equatable/equatable.dart';

// Events
abstract class NoteDetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GenerateMessage extends NoteDetailEvent {
  final String category;
  final String prompt;
  final String imagePrompt;

  GenerateMessage({
    required this.category,
    required this.prompt,
    required this.imagePrompt,
  });

  @override
  List<Object> get props => [category, prompt, imagePrompt];
}
