import 'package:equatable/equatable.dart';
import '../../domain/models/message_history.dart';

// States
abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<MessageHistory> history;

  const HistoryLoaded(this.history);

  @override
  List<Object> get props => [history];
}

class HistoryError extends HistoryState {
  final String message;

  const HistoryError(this.message);

  @override
  List<Object> get props => [message];
}
