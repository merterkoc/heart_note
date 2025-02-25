import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heart_note/features/message/presentation/bloc/history_event.dart';
import 'package:heart_note/features/message/presentation/widgets/keyword_selector.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../core/entities/message_category.dart';
import '../bloc/note_detail_bloc.dart';
import '../bloc/note_detail_event.dart';
import '../bloc/note_detail_state.dart';
import '../../../../core/services/gemini_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/message_history.dart';
import '../bloc/history_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../../core/utils/ad_helper.dart';

class MessageResultPage extends StatefulWidget {
  final MessageCategory category;
  final List<String> selectedKeywords;
  final String recipient;
  final String tone;

  const MessageResultPage({
    super.key,
    required this.category,
    required this.selectedKeywords,
    required this.recipient,
    required this.tone,
  });

  @override
  State<MessageResultPage> createState() => _MessageResultPageState();
}

class _MessageResultPageState extends State<MessageResultPage> {
  bool _autoSave = false;
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;
  final AdHelper _adHelper = AdHelper.create();

  @override
  void initState() {
    _loadAutoSavePreference();
    super.initState();
    _loadBannerAd();
  }

  Future<void> _loadAutoSavePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _autoSave = prefs.getBool('autoSave') ?? false;
  }

  void _loadBannerAd() {
    final adUnitId = _adHelper.getAdUnitId(AdType.banner);
    if (adUnitId == null) {
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd opened.'),
        onAdClosed: (Ad ad) => print('$BannerAd closed.'),
      ),
    );

    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _showAlert(BuildContext context, String message) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: Text(message),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NoteDetailBloc(
        geminiService: GeminiService(),
      )..add(
          GenerateMessage(
            category: widget.category.title,
            imagePrompt: widget.category.imagePrompt,
            prompt:
                'Kime: ${widget.recipient}, Hitap: ${widget.tone}, Anahtar kelimeler: ${widget.selectedKeywords.join(", ")}',
          ),
        ),
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Oluşturulan Mesaj'),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocListener<NoteDetailBloc, NoteDetailState>(
              listenWhen: (previous, current) =>
                  previous is NoteDetailLoading && current is NoteDetailLoaded,
              listener: (context, state) {
                if (state is NoteDetailLoaded && _autoSave) {
                  _saveToHistory(
                    context,
                    state.message,
                    state.imageUrl,
                    widget.selectedKeywords,
                    widget.category,
                  );
                }
              },
              child: BlocBuilder<NoteDetailBloc, NoteDetailState>(
                builder: (context, state) {
                  if (state is NoteDetailLoading) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  if (state is NoteDetailError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.exclamationmark_circle,
                            size: 48,
                            color: CupertinoColors.destructiveRed,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: const TextStyle(
                              color: CupertinoColors.destructiveRed,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is NoteDetailLoaded) {
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          children: [
                            if (state.imageUrl != null)
                              Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: MemoryImage(
                                      base64Decode(state.imageUrl!),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8.0,
                              children: widget.selectedKeywords.map((keyword) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey6,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: CupertinoColors.systemGrey4,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      DefaultTextStyle(
                                        style: CupertinoTheme.of(context)
                                            .textTheme
                                            .textStyle
                                            .copyWith(
                                              color: CupertinoColors.label,
                                            ),
                                        child: Text(keyword),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        if (_isBannerAdReady)
                          SizedBox(
                            width: _bannerAd!.size.width.toDouble(),
                            height: _bannerAd!.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd!),
                          ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _shareContent(String message, String? imageUrl) async {
    if (imageUrl != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = File('${directory.path}/shared_image.png');
      final imageBytes = base64Decode(imageUrl);
      await imagePath.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(imagePath.path)],
        text: message,
        subject: message,
        sharePositionOrigin: const Rect.fromLTRB(10, 10, 2.5, 2.5),
      );
    } else {
      Share.share(message);
    }
  }

  Future<void> _saveToHistory(
      BuildContext context,
      String message,
      String? imageUrl,
      List<String> selectedKeywords,
      MessageCategory category) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList('message_history') ?? [];

    // Check if the message already exists
    final existingMessageIndex = historyJson.indexWhere((element) {
      final existingHistory = MessageHistory.fromJson(jsonDecode(element));
      return existingHistory.message == message &&
          existingHistory.category == category.title;
    });

    if (existingMessageIndex != -1) {
      _showAlert(context, 'Bu mesaj zaten kaydedilmiş!');
      return;
    }

    final history = MessageHistory(
      category: category.title,
      message: message,
      imageUrl: imageUrl,
      keywords: selectedKeywords,
      createdAt: DateTime.now(),
    );

    historyJson.add(jsonEncode(history.toJson()));
    await prefs.setStringList('message_history', historyJson);

    // ignore: use_build_context_synchronously
    BlocProvider.of<HistoryBloc>(context).add(LoadHistory());
    _showAlert(context, 'Mesaj başarıyla kaydedildi!');
  }
}
