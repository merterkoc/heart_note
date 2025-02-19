import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/entities/message_category.dart';

class CategoryDetailPage extends StatefulWidget {
  final MessageCategory category;

  const CategoryDetailPage({Key? key, required this.category})
      : super(key: key);

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  List<String> selectedKeywords = [];

  final List<String> keywords = [
    'Aşk',
    'Sevgi',
    'Mutluluk',
    'Huzur',
    'Özlem',
    'Hasret',
    'Umut',
    'Hayal',
    'Gelecek',
    'Anı',
  ];

  void _toggleKeyword(String keyword) {
    setState(() {
      if (selectedKeywords.contains(keyword)) {
        selectedKeywords.remove(keyword);
      } else {
        selectedKeywords.add(keyword);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('${widget.category.title} için Mesaj Oluştur'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Mesajınızda hangi anahtar kelimeler bulunsun?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 8.0,
                children: keywords.map((keyword) {
                  return FilterChip(
                    label: Text(keyword),
                    selected: selectedKeywords.contains(keyword),
                    onSelected: (bool selected) {
                      _toggleKeyword(keyword);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              CupertinoButton.filled(
                onPressed: selectedKeywords.isEmpty
                    ? null
                    : () {
                        context.push(
                          '/recipient',
                          extra: {
                            'selectedKeywords': selectedKeywords,
                            'category': widget.category,
                          },
                        );
                      },
                child: const Text('Devam'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
