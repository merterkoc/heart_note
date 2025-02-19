import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/entities/message_category.dart';
import '../../../../core/router/router.dart';

class RecipientPage extends StatefulWidget {
  final List<String> selectedKeywords;
  final MessageCategory category;

  const RecipientPage({
    Key? key,
    required this.selectedKeywords,
    required this.category,
  }) : super(key: key);

  @override
  State<RecipientPage> createState() => _RecipientPageState();
}

class _RecipientPageState extends State<RecipientPage> {
  String? _recipient;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Kime?'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Mesajı kime yazıyorsunuz?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              CupertinoSlidingSegmentedControl<String>(
                groupValue: _recipient,
                children: const {
                  'Sevgili': Text('Sevgili'),
                  'En İyi Arkadaş': Text('En İyi Arkadaş'),
                  'Dost': Text('Dost'),
                  'Kardeş': Text('Kardeş'),
                  'Aile': Text('Aile'),
                  'Diğer': Text('Diğer'),
                },
                onValueChanged: (String? value) {
                  setState(() {
                    _recipient = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              CupertinoButton.filled(
                onPressed: _recipient == null
                    ? null
                    : () {
                        context.push(
                          AppRoute.tone.path,
                          extra: {
                            'selectedKeywords': widget.selectedKeywords,
                            'category': widget.category,
                            'recipient': _recipient,
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
