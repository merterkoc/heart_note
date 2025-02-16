import 'package:flutter/material.dart';
import '../../../../core/entities/message_keyword.dart';

class KeywordSelector extends StatefulWidget {
  final List<MessageKeyword> keywords;
  final Function(List<String>) onKeywordsSelected;

  const KeywordSelector({
    super.key,
    required this.keywords,
    required this.onKeywordsSelected,
  });

  @override
  State<KeywordSelector> createState() => _KeywordSelectorState();
}

class _KeywordSelectorState extends State<KeywordSelector> {
  late List<MessageKeyword> _keywords;

  @override
  void initState() {
    super.initState();
    _keywords =
        widget.keywords.map((k) => k.copyWith(isSelected: false)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _keywords.map((keyword) {
        return FilterChip(
          label: Text(keyword.text),
          selected: keyword.isSelected,
          onSelected: (selected) {
            setState(() {
              _keywords = _keywords.map((k) {
                if (k.text == keyword.text) {
                  return k.copyWith(isSelected: selected);
                }
                return k;
              }).toList();

              // State güncellendikten sonra seçili kelimeleri gönder
              final selectedKeywords = _keywords
                  .where((k) => k.isSelected)
                  .map((k) => k.text)
                  .toList();

              widget.onKeywordsSelected(selectedKeywords);
            });
          },
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          checkmarkColor: Theme.of(context).colorScheme.primary,
        );
      }).toList(),
    );
  }

  @override
  void didUpdateWidget(KeywordSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.keywords != widget.keywords) {
      _keywords =
          widget.keywords.map((k) => k.copyWith(isSelected: false)).toList();
    }
  }
}
