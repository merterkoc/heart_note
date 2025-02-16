import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/message_repository.dart';
import '../../../../core/entities/message_category.dart';

// Events
abstract class MessageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadCategories extends MessageEvent {}

// States
abstract class MessageState extends Equatable {
  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final List<MessageCategory> categories;

  MessageLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class MessageError extends MessageState {
  final String message;

  MessageError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository repository;

  MessageBloc({required this.repository}) : super(MessageInitial()) {
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageLoading());
    try {
      final categories = await repository.getCategories();
      emit(MessageLoaded(categories));
    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }
}
