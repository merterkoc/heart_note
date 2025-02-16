import 'package:equatable/equatable.dart';

class MessageHistory extends Equatable {
  final String category;
  final String message;
  final String? imageUrl;
  final List<String> keywords;
  final DateTime createdAt;

  const MessageHistory({
    required this.category,
    required this.message,
    this.imageUrl,
    required this.keywords,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'message': message,
      'imageUrl': imageUrl,
      'keywords': keywords,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MessageHistory.fromJson(Map<String, dynamic> json) {
    return MessageHistory(
      category: json['category'],
      message: json['message'],
      imageUrl: json['imageUrl'],
      keywords: List<String>.from(json['keywords']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  List<Object?> get props => [category, message, imageUrl, keywords, createdAt];
}
