import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/message_repository.dart';
import 'message_event.dart';
import 'message_state.dart';

// Bloc
class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository repository;

  MessageBloc({required this.repository}) : super(MessageLoading()) {
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<MessageState> emit,
  ) async {
    try {
      emit(MessageLoading());
      final categories = await repository.getCategories();
      emit(MessageLoaded(categories));
    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }
}
