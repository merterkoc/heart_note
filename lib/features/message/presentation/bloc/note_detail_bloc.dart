import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/gemini_service.dart';
import 'note_detail_event.dart';
import 'note_detail_state.dart';

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
    emit(NoteDetailLoading());
    try {
      final message = await geminiService.generateMessage(event.category, event.prompt);
      final imageUrl = await geminiService.generateImage(event.imagePrompt);

      emit(NoteDetailLoaded(message: message!, imageUrl: imageUrl));
    } catch (e) {
      emit(NoteDetailError(e.toString()));
    }
  }
}
