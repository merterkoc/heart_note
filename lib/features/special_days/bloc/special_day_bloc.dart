import 'dart:async';
import 'dart:convert';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/entities/special_day.dart';
import 'package:device_calendar/device_calendar.dart';
import 'special_day_event.dart';
import 'special_day_state.dart';

// Bloc
class SpecialDayBloc extends Bloc<SpecialDayEvent, SpecialDayState> {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  SpecialDayBloc() : super(const SpecialDayState()) {
    on<LoadSpecialDays>(_onLoadSpecialDays);
    on<AddSpecialDay>(_onAddSpecialDay);
    on<DeleteSpecialDay>(_onDeleteSpecialDay);
    on<ImportSpecialDays>(_onImportSpecialDays);
    on<SaveImportedSpecialDays>(_onSaveImportedSpecialDays);
    on<DeleteAllSpecialDays>(_onDeleteAllSpecialDays);
    on<UpdateIsChecked>(_onUpdateIsChecked);
    on<OpenCalendarSettings>(_onOpenCalendarSettings);
  }

  Future<void> _onLoadSpecialDays(
    LoadSpecialDays event,
    Emitter<SpecialDayState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final prefs = await SharedPreferences.getInstance();
      final specialDaysJson = prefs.getStringList('special_days') ?? [];
      final specialDays = specialDaysJson
          .map((e) => SpecialDay.fromJson(jsonDecode(e)))
          .toList();
      emit(state.copyWith(isLoading: false, specialDays: specialDays));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, errorMessage: e.toString(), specialDays: []));
    }
  }

  Future<void> _onAddSpecialDay(
    AddSpecialDay event,
    Emitter<SpecialDayState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final prefs = await SharedPreferences.getInstance();
      final specialDaysJson = prefs.getStringList('special_days') ?? [];
      final specialDay = event.specialDay;
      specialDaysJson.add(jsonEncode(specialDay.toJson()));
      await prefs.setStringList('special_days', specialDaysJson);
      List<SpecialDay> updatedList = List.from(state.specialDays)
        ..add(specialDay);
      emit(state.copyWith(specialDays: updatedList, isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> _onDeleteSpecialDay(
    DeleteSpecialDay event,
    Emitter<SpecialDayState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      final prefs = await SharedPreferences.getInstance();
      final specialDaysJson = prefs.getStringList('special_days') ?? [];
      specialDaysJson.removeAt(event.index);
      await prefs.setStringList('special_days', specialDaysJson);
      final updatedList = List<SpecialDay>.from(state.specialDays)
        ..removeAt(event.index);
      emit(state.copyWith(specialDays: updatedList, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false,
          errorMessage: e.toString()));
    }
  }

  Future<void> _onImportSpecialDays(
    ImportSpecialDays event,
    Emitter<SpecialDayState> emit,
  ) async {
    emit(state.copyWith(errorMessage: null, isLoading: true));
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
          return emit(state.copyWith(
              isLoading: false, calendarPermissionGranted: false));
        } else {
          return emit(state.copyWith(calendarPermissionGranted: true));
        }
      }else {
         emit(state.copyWith(calendarPermissionGranted: true));
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      if (calendarsResult.isSuccess && calendarsResult.data != null) {
        final calendars = calendarsResult.data!;
        List<SpecialDay> importedSpecialDays = [];
        for (var calendar in calendars) {
          final startDate = DateTime.now().subtract(const Duration(days: 365));
          final endDate = DateTime.now().add(const Duration(days: 365));
          final eventsResult = await _deviceCalendarPlugin.retrieveEvents(
            calendar.id,
            RetrieveEventsParams(startDate: startDate, endDate: endDate),
          );

          if (eventsResult.isSuccess && eventsResult.data != null) {
            final events = eventsResult.data!;
            for (var event in events) {
              // Event'leri SpecialDay'e dönüştür ve ekle
              final specialDay = SpecialDay(
                  title: event.title ?? 'Etkinlik',
                  date: event.start ?? DateTime.now());
              importedSpecialDays.add(specialDay);
            }
          }
        }

        // isCheckedList'i oluştur
        List<bool?> isCheckedList =
            List.generate(importedSpecialDays.length, (index) => false);

        emit(state.copyWith(
            isLoading: false,
            importedSpecialDays: importedSpecialDays,
            isCheckedList: isCheckedList));
      } else {
        emit(state.copyWith(
            isLoading: false,
            errorMessage:
                calendarsResult.errors.toString())); // Hata durumunu işle
      }
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, errorMessage: e.toString(), specialDays: []));
    }
  }

  Future<void> _onSaveImportedSpecialDays(
      SaveImportedSpecialDays event,
      Emitter<SpecialDayState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final prefs = await SharedPreferences.getInstance();

      // Zaten state içinde olan özel günleri filtrele
      final newSpecialDays = event.specialDays
          .where((day) => !state.specialDays.contains(day))
          .toList();

      // Eğer eklenecek yeni gün yoksa işlemi durdur
      if (newSpecialDays.isEmpty) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      // JSON olarak kaydetme işlemi
      final specialDaysJson =
      newSpecialDays.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList('special_days', [
        ...?prefs.getStringList('special_days'),
        ...specialDaysJson
      ]);

      // State'i güncelle
      emit(state.copyWith(
        isLoading: false,
        specialDays: [...state.specialDays, ...newSpecialDays],
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteAllSpecialDays(
    DeleteAllSpecialDays event,
    Emitter<SpecialDayState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('special_days');
      emit(state.copyWith(isLoading: false, specialDays: []));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateIsChecked(
    UpdateIsChecked event,
    Emitter<SpecialDayState> emit,
  ) async {
    final List<bool?> updatedIsCheckedList = List.from(state.isCheckedList);
    updatedIsCheckedList[event.index] = event.value;

    emit(state.copyWith(isCheckedList: updatedIsCheckedList));
  }

  FutureOr<void> _onOpenCalendarSettings(
      OpenCalendarSettings event, Emitter<SpecialDayState> emit) {
    AppSettings.openAppSettings();
  }
}
