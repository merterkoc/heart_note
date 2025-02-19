import 'package:equatable/equatable.dart';
import '../../../../core/entities/message_category.dart';

// States
abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final List<MessageCategory> categories;

  const MessageLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class MessageError extends MessageState {
  final String message;

  const MessageError(this.message);

  @override
  List<Object> get props => [message];
}
