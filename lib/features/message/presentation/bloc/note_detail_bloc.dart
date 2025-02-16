import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/services/gemini_service.dart';

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
    required this.imagePrompt,
    this.prompt = '',
  });

  @override
  List<Object> get props => [category, imagePrompt, prompt];
}

// States
abstract class NoteDetailState extends Equatable {
  @override
  List<Object> get props => [];
}

class NoteDetailInitial extends NoteDetailState {}

class NoteDetailLoading extends NoteDetailState {}

class NoteDetailLoaded extends NoteDetailState {
  final String message;
  final String? imageUrl;

  NoteDetailLoaded({
    required this.message,
    this.imageUrl,
  });
}

class NoteDetailError extends NoteDetailState {
  final String error;

  NoteDetailError(this.error);

  @override
  List<Object> get props => [error];
}

// Bloc
class NoteDetailBloc extends Bloc<NoteDetailEvent, NoteDetailState> {
  final GeminiService geminiService;

  NoteDetailBloc({required this.geminiService}) : super(NoteDetailInitial()) {
    on<GenerateMessage>(_onGenerateMessage);
  }

  Future<void> _onGenerateMessage(
    GenerateMessage event,
    Emitter<NoteDetailState> emit,
  ) async {
    try {
      emit(NoteDetailLoading());

      final message = await geminiService.generateMessage(
        event.category,
        event.prompt,
      );

      final imageUrl = await geminiService.generateImage(event.imagePrompt);

      emit(NoteDetailLoaded(
        message: message,
        imageUrl: imageUrl,
      ));
    } catch (e) {
      emit(NoteDetailError(e.toString()));
    }
  }
}
