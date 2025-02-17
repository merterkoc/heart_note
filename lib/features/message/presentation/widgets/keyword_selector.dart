import 'package:flutter/cupertino.dart';
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
        return GestureDetector(
          onTap: () {
            setState(() {
              _keywords = _keywords.map((k) {
                if (k.text == keyword.text) {
                  return k.copyWith(isSelected: !k.isSelected);
                }
                return k;
              }).toList();

              final selectedKeywords = _keywords
                  .where((k) => k.isSelected)
                  .map((k) => k.text)
                  .toList();

              widget.onKeywordsSelected(selectedKeywords);
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: keyword.isSelected
                  ? CupertinoTheme.of(context).primaryColor.withOpacity(0.2)
                  : CupertinoColors.systemGrey6,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: keyword.isSelected
                    ? CupertinoTheme.of(context).primaryColor
                    : CupertinoColors.systemGrey4,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultTextStyle(
                  style: keyword.isSelected
                      ? CupertinoTheme.of(context)
                          .textTheme
                          .navTitleTextStyle
                          .copyWith(
                            color: CupertinoTheme.of(context).primaryColor,
                          )
                      : CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                            color: CupertinoColors.label,
                          ),
                  child: Text(keyword.text),
                ),
                if (keyword.isSelected) ...[
                  const SizedBox(width: 4),
                  Icon(
                    CupertinoIcons.checkmark_alt,
                    size: 16,
                    color: CupertinoTheme.of(context).primaryColor,
                  ),
                ],
              ],
            ),
          ),
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
