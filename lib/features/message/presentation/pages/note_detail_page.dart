import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          widget.category.icon,
                          size: 24,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.category.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.category.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Anahtar Kelimeler',
              style: Theme.of(context).textTheme.titleMedium,
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
      floatingActionButton: selectedKeywords.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                context.push(
                  '/result/${widget.category.title}',
                  extra: {
                    'category': widget.category,
                    'keywords': selectedKeywords,
                  },
                );
              },
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Mesaj Oluştur'),
            )
          : null,
    );
  }
}
