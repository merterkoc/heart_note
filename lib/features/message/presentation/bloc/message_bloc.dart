import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heart_note/core/entities/message_keyword.dart';
import 'package:heart_note/core/entities/special_day.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/entities/message_category.dart';
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
      try {
        final prefs = await SharedPreferences.getInstance();
        final specialDaysJson = prefs.getStringList('special_days') ?? [];
        final specialDays = specialDaysJson
            .map((e) => SpecialDay.fromJson(jsonDecode(e)))
            .toList();
        final List<MessageCategory> specialDaysCategories = specialDays
            .map((e) => MessageCategory(
                  title: e.title,
                  description: e.description ?? 'Özel Gün',
                  icon: Icons.calendar_month,
                  imagePrompt: e.title,
                  prompt: [
                    MessageKeyword(text: e.title),
                  ],
                ))
            .toList();

        emit(MessageLoaded(categories, specialDaysCategories));
      } catch (e) {
        emit(MessageLoaded(categories, null));
        rethrow;
      }
    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }
}
