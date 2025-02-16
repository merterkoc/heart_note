import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'message_keyword.dart';

class MessageCategory extends Equatable {
  final String title;
  final IconData icon;
  final String description;
  final List<MessageKeyword> prompt;
  final String imagePrompt;

  const MessageCategory({
    required this.title,
    required this.icon,
    required this.description,
    required this.prompt,
    required this.imagePrompt,
  });

  @override
  List<Object> get props => [title, icon, description, prompt, imagePrompt];
}
