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

  final List<String> _recipientOptions = [
    // Romantik İlişkiler
    'Sevgili',
    'Eş',
    'Nişanlı',
    'Partner',
    'Hayat Arkadaşı',

    // Aile Bireyleri
    'Anne',
    'Baba',
    'Kardeş',
    'Ağabey',
    'Abla',
    'Kuzen',
    'Dede',
    'Nine',
    'Amca',
    'Teyze',
    'Dayı',
    'Hala',

    // Arkadaşlık ve Sosyal Çevre
    'En İyi Arkadaş',
    'Dost',
    'Çocukluk Arkadaşı',
    'İş Arkadaşı',
    'Sırdaş',
    'Komşu',
    'Üniversite Arkadaşı',

    // İş ve Resmi İlişkiler
    'Patron',
    'Çalışan',
    'Müşteri',
    'Öğretmen',
    'Öğrenci',
    'Danışman',

    // Özel Gruplar
    'Aile',
    'Ekip Arkadaşı',
    'Topluluk Üyesi',
    'Spor Takımı Arkadaşı',

    // Genel Kullanımlar
    'Değerli Birisi',
    'Hayran',
    'Destekçim',
    'Yoldaş',
    'Kahramanım',
    'Diğer'
  ];
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Kime?'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
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
          alignment: Alignment.center,
          child: const Icon(CupertinoIcons.arrow_right),
        ),
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
              Expanded(
                child: ListView.builder(
                  itemCount: _recipientOptions.length,
                  itemBuilder: (context, index) {
                    final recipient = _recipientOptions[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CupertinoButton(
                        color: _recipient == recipient
                            ? CupertinoColors.destructiveRed
                            : CupertinoColors.lightBackgroundGray,
                        padding: const EdgeInsets.all(16),
                        borderRadius: BorderRadius.circular(12),
                        onPressed: () {
                          setState(() {
                            _recipient = recipient;
                          });
                        },
                        child: Text(
                          recipient,
                          style: TextStyle(
                            color: _recipient == recipient
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