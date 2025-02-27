import 'package:equatable/equatable.dart';
import '../../../../core/entities/message_category.dart';

// States
abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object?> get props => [];
}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final List<MessageCategory> categories;
  final List<MessageCategory>? customEvents;

  const MessageLoaded(this.categories, this.customEvents);

  @override
  List<Object?> get props => [categories, customEvents];
}

class MessageError extends MessageState {
  final String message;

  const MessageError(this.message);

  @override
  List<Object> get props => [message];
}
