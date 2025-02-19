import 'package:equatable/equatable.dart';

// Events
abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadHistory extends HistoryEvent {}

class DeleteHistory extends HistoryEvent {
  final int index;

  const DeleteHistory(this.index);

  @override
  List<Object> get props => [index];
}