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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Hitap'),
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
              CupertinoSlidingSegmentedControl<String>(
                groupValue: _tone,
                children: const {
                  'Sen': Text('Sen'),
                  'Siz': Text('Siz'),
                },
                onValueChanged: (String? value) {
                  setState(() {
                    _tone = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              CupertinoButton.filled(
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
                child: const Text('Mesajı Oluştur'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
