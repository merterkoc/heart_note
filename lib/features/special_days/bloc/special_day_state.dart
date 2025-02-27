import 'package:equatable/equatable.dart';
import '../../../core/entities/special_day.dart';

// States
class SpecialDayState extends Equatable {
  final List<SpecialDay> specialDays;
  final List<SpecialDay> importedSpecialDays;
  final List<bool?> isCheckedList;
  final bool isLoading;
  final String? errorMessage;
  final bool calendarPermissionGranted;

  const SpecialDayState({
    this.specialDays = const [],
    this.importedSpecialDays = const [],
    this.isCheckedList = const [],
    this.isLoading = false,
    this.errorMessage,
    this.calendarPermissionGranted = false,
  });

  SpecialDayState copyWith({
    List<SpecialDay>? specialDays,
    List<SpecialDay>? importedSpecialDays,
    List<bool?>? isCheckedList,
    bool? isLoading,
    String? errorMessage,
    bool? calendarPermissionGranted,
  }) {
    return SpecialDayState(
      specialDays: specialDays ?? this.specialDays,
      importedSpecialDays: importedSpecialDays ?? this.importedSpecialDays,
      isCheckedList: isCheckedList ?? this.isCheckedList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      calendarPermissionGranted: calendarPermissionGranted ?? this.calendarPermissionGranted,
    );
  }

  @override
  List<Object?> get props => [
        specialDays,
        importedSpecialDays,
        isCheckedList,
        isLoading,
        errorMessage,
        calendarPermissionGranted,
      ];
}

class SpecialDayLoading extends SpecialDayState {}

class SpecialDayLoaded extends SpecialDayState {
  final List<SpecialDay> specialDays;

  const SpecialDayLoaded(this.specialDays);

  @override
  List<Object> get props => [specialDays];
}

class SpecialDayError extends SpecialDayState {
  final String message;

  const SpecialDayError(this.message);

  @override
  List<Object> get props => [message];
}
