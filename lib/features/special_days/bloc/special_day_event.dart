import 'package:equatable/equatable.dart';
import '../../../core/entities/special_day.dart';

// Events
abstract class SpecialDayEvent extends Equatable {
  const SpecialDayEvent();

  @override
  List<Object> get props => [];
}

class LoadSpecialDays extends SpecialDayEvent {}

class AddSpecialDay extends SpecialDayEvent {
  final SpecialDay specialDay;

  const AddSpecialDay(this.specialDay);

  @override
  List<Object> get props => [specialDay];
}

class DeleteSpecialDay extends SpecialDayEvent {
  final int index;

  const DeleteSpecialDay(this.index);

  @override
  List<Object> get props => [index];
}

class ImportSpecialDays extends SpecialDayEvent {}

class SaveImportedSpecialDays extends SpecialDayEvent {
  final List<SpecialDay> specialDays;

  const SaveImportedSpecialDays(this.specialDays);

  @override
  List<Object> get props => [specialDays];
}

class DeleteAllSpecialDays extends SpecialDayEvent {}

class LoadImportedSpecialDays extends SpecialDayEvent {}

class UpdateIsChecked extends SpecialDayEvent {
  final int index;
  final bool value;

  const UpdateIsChecked({required this.index, required this.value});

  @override
  List<Object> get props => [index, value ?? false];
}

class OpenCalendarSettings extends SpecialDayEvent {}