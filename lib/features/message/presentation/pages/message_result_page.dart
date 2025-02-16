import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../core/entities/message_category.dart';
import '../bloc/note_detail_bloc.dart';
import '../../../../core/services/gemini_service.dart';
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

    await Share.shareXFiles(
      files,
      text: message,
    );
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mesaj kaydedildi!')),
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Oluşturulan Mesaj'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<NoteDetailBloc, NoteDetailState>(
            builder: (context, state) {
              if (state is NoteDetailLoading) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Mesajınız ve görseller oluşturuluyor...'),
                    ],
                  ),
                );
              }
              if (state is NoteDetailLoaded) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.imageUrl != null) ...[
                        Card(
                          clipBehavior: Clip.antiAlias,
                          child: Image.memory(
                            base64Decode(state.imageUrl!),
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox(
                                height: 300,
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 48,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    category.icon,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Mesajınız Hazır!',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                state.message,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        children: selectedKeywords
                            .map(
                              (keyword) => Chip(
                                label: Text(keyword),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                );
              }
              if (state is NoteDetailError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.error,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
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
        floatingActionButton: BlocBuilder<NoteDetailBloc, NoteDetailState>(
          builder: (context, state) {
            if (state is NoteDetailLoaded) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: 'share',
                    onPressed: () =>
                        _shareContent(state.message, state.imageUrl),
                    tooltip: 'Mesajı Paylaş',
                    child: const Icon(Icons.share),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton(
                    heroTag: 'copy',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: state.message));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mesaj kopyalandı!'),
                        ),
                      );
                    },
                    tooltip: 'Mesajı Kopyala',
                    child: const Icon(Icons.copy),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton(
                    heroTag: 'save',
                    onPressed: () =>
                        _saveToHistory(context, state.message, state.imageUrl),
                    tooltip: 'Kaydet',
                    child: const Icon(Icons.save),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
