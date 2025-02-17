import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heart_note/core/services/gemini_service.dart';
import '../../../../core/entities/message_category.dart';
import '../bloc/note_detail_bloc.dart';
import '../widgets/keyword_selector.dart';
import 'package:go_router/go_router.dart';

class NoteDetailPage extends StatefulWidget {
  final MessageCategory category;

  const NoteDetailPage({
    super.key,
    required this.category,
  });

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  List<String> selectedKeywords = [];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.category.title),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: selectedKeywords.isNotEmpty
              ? () => context.push(
                    '/result/${widget.category.title}',
                    extra: {
                      'category': widget.category,
                      'keywords': selectedKeywords,
                    },
                  )
              : null,
          child: Icon(
            CupertinoIcons.arrow_right,

          ),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: CupertinoColors.systemGrey4),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          widget.category.icon,
                          color: CupertinoTheme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.category.title,
                          style: CupertinoTheme.of(context)
                              .textTheme
                              .navTitleTextStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.category.description,
                      style: CupertinoTheme.of(context)
                          .textTheme
                          .tabLabelTextStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Anahtar Kelimeler',
                style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
              ),
              const SizedBox(height: 8),
              KeywordSelector(
                keywords: widget.category.prompt,
                onKeywordsSelected: (keywords) {
                  setState(() {
                    selectedKeywords = keywords;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
