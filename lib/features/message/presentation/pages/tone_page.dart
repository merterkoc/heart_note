import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/entities/message_category.dart';
import '../../../../core/router/router.dart';

class TonePage extends StatefulWidget {
  final List<String> selectedKeywords;
  final MessageCategory category;
  final String recipient;

  const TonePage({
    super.key,
    required this.selectedKeywords,
    required this.category,
    required this.recipient,
  });

  @override
  State<TonePage> createState() => _TonePageState();
}

class _TonePageState extends State<TonePage> {
  String? _tone;

  final List<String> _toneOptions = [
    'Sen',
    'Siz',
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Hitap'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _tone == null
              ? null
              : () {
                  context.push(
                    AppRoute.messageResult.path,
                    extra: {
                      'selectedKeywords': widget.selectedKeywords,
                      'category': widget.category,
                      'recipient': widget.recipient,
                      'tone': _tone,
                    },
                  );
                },
          child: const Icon(CupertinoIcons.arrow_right),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Nasıl hitap edersiniz?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: _toneOptions.length,
                  itemBuilder: (context, index) {
                    final tone = _toneOptions[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CupertinoButton(
                        color: _tone == tone
                            ? CupertinoColors.destructiveRed
                            : CupertinoColors.lightBackgroundGray,
                        padding: const EdgeInsets.all(16),
                        borderRadius: BorderRadius.circular(12),
                        onPressed: () {
                          setState(() {
                            _tone = tone;
                          });
                        },
                        child: Text(
                          tone,
                          style: TextStyle(
                            color: _tone == tone
                                ? CupertinoColors.white
                                : CupertinoColors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
