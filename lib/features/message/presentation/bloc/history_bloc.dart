import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/models/message_history.dart';
import 'history_event.dart';
import 'history_state.dart';

// Bloc
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryLoading()) {
    on<LoadHistory>(_onLoadHistory);
    on<DeleteHistory>(_onDeleteHistory);
  }

  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList('message_history') ?? [];
      final history = historyJson
          .map((e) => MessageHistory.fromJson(jsonDecode(e)))
          .toList();
      emit(HistoryLoaded(history));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<void> _onDeleteHistory(
    DeleteHistory event,
    Emitter<HistoryState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList('message_history') ?? [];
      historyJson.removeAt(event.index);
      await prefs.setStringList('message_history', historyJson);
      add(LoadHistory()); // Tetikleme LoadHistory event'i
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
