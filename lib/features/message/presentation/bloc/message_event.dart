import 'package:equatable/equatable.dart';

// Events
abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class LoadCategories extends MessageEvent {}
