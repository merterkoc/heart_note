import 'package:equatable/equatable.dart';

class SpecialDay extends Equatable {
  final String title;
  final DateTime date;
  final String? description;

  const SpecialDay({
    required this.title,
    required this.date,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  factory SpecialDay.fromJson(Map<String, dynamic> json) {
    return SpecialDay(
      title: json['title'],
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }

  @override
  List<Object?> get props => [title, date, description];
}
