import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class MessageCategory extends Equatable {
  final String title;
  final IconData icon;
  final String description;

  const MessageCategory({
    required this.title,
    required this.icon,
    required this.description,
  });

  @override
  List<Object> get props => [title, icon, description];
}
