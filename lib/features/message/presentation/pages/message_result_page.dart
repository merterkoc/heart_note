import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../core/entities/message_category.dart';
import '../bloc/note_detail_bloc.dart';
import '../../../../core/services/gemini_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/message_history.dart';

class MessageResultPage extends StatelessWidget {
  final MessageCategory category;
  final List<String> selectedKeywords;

  const MessageResultPage({
    super.key,
    required this.category,
    required this.selectedKeywords,
  });

  Future<void> _shareContent(String message, String? imageBase64) async {
    List<XFile> files = [];
    if (imageBase64 != null) {
      try {
        final bytes = base64Decode(imageBase64);
        final tempDir = await getTemporaryDirectory();
        final imagePath = '${tempDir.path}/shared_image.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(bytes);
        files.add(XFile(imagePath));
      } catch (e) {
        print('Görsel paylaşma hatası: $e');
      }
    }
    await Share.shareXFiles(files, text: message);
  }

  Future<void> _saveToHistory(
      BuildContext context, String message, String? imageUrl) async {
    final history = MessageHistory(
      category: category.title,
      message: message,
      imageUrl: imageUrl,
      keywords: selectedKeywords,
      createdAt: DateTime.now(),
    );

    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList('message_history') ?? [];
    historyJson.add(jsonEncode(history.toJson()));
    await prefs.setStringList('message_history', historyJson);

    _showAlert(context, 'Mesaj kaydedildi!');
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
            category: category.title,
            imagePrompt: category.imagePrompt,
            prompt: 'Anahtar kelimeler: ${selectedKeywords.join(", ")}',
          ),
        ),
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Oluşturulan Mesaj'),
        ),
        child: SafeArea(
          child: BlocBuilder<NoteDetailBloc, NoteDetailState>(
            builder: (context, state) {
              if (state is NoteDetailLoading) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              if (state is NoteDetailLoaded) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(

                        child: SafeArea(
                          top: false,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CupertinoButton(
                                onPressed: () => _shareContent(
                                  state.message,
                                  state.imageUrl,
                                ),
                                child: const Icon(CupertinoIcons.share),
                              ),
                              CupertinoButton(
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: state.message),
                                  );
                                  _showAlert(context, 'Mesaj kopyalandı!');
                                },
                                child: const Icon(CupertinoIcons.doc_on_doc),
                              ),
                              CupertinoButton(
                                onPressed: () => _saveToHistory(
                                  context,
                                  state.message,
                                  state.imageUrl,
                                ),
                                child: const Icon(CupertinoIcons.floppy_disk),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              if (state is NoteDetailError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.exclamationmark_circle,
                        color: CupertinoColors.destructiveRed,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.error,
                        style: const TextStyle(
                          color: CupertinoColors.destructiveRed,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
