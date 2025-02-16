class MessageKeyword {
  final String text;
  final bool isSelected;

  const MessageKeyword({
    required this.text,
    this.isSelected = false,
  });

  MessageKeyword copyWith({
    String? text,
    bool? isSelected,
  }) {
    return MessageKeyword(
      text: text ?? this.text,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
