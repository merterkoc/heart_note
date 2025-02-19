import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heart_note/core/entities/message_keyword.dart';
import 'package:heart_note/features/message/presentation/widgets/keyword_selector.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../domain/models/message_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryDetailPage extends StatefulWidget {
  final MessageHistory message;
  final int index;

  const HistoryDetailPage({
    super.key,
    required this.message,
    required this.index,
  });

  @override
  State<HistoryDetailPage> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  late TextEditingController _messageController;
  late final String _originalMessage;
  late String _currentMessage;

  @override
  void initState() {
    super.initState();
    _originalMessage = widget.message.message;
    _currentMessage = widget.message.message;
    _messageController = TextEditingController(text: widget.message.message);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

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

  Future<void> _updateMessage() async {
    final updatedMessage = MessageHistory(
      category: widget.message.category,
      message: _currentMessage,
      imageUrl: widget.message.imageUrl,
      keywords: widget.message.keywords,
      createdAt: widget.message.createdAt,
    );

    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList('message_history') ?? [];
    historyJson[widget.index] = jsonEncode(updatedMessage.toJson());
    await prefs.setStringList('message_history', historyJson);

    _showAlert('Mesaj güncellendi!');
  }

  void _resetMessage() {
    setState(() {
      _messageController.text = _originalMessage;
      _currentMessage = _originalMessage;
    });
    _showAlert('Mesaj ilk haline döndürüldü');
  }

  void _showAlert(String message) {
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
    final bool isEdited = _currentMessage != _originalMessage;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.message.category),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isEdited)
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _resetMessage,
                child: const Icon(CupertinoIcons.arrow_counterclockwise),
              ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: isEdited ? _updateMessage : null,
              child: Icon(
                CupertinoIcons.check_mark,
                color: isEdited ? null : CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
      ),
      child: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.message.imageUrl != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        base64Decode(widget.message.imageUrl!),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            height: 200,
                            child: Center(
                              child: Icon(
                                CupertinoIcons.photo_fill_on_rectangle_fill,
                                size: 48,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  CupertinoTextField(
                    controller: _messageController,
                    maxLines: null,
                    onChanged: (value) {
                      setState(() {
                        _currentMessage = value;
                      });
                    },
                    placeholder: 'Mesajınızı düzenleyin...',
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: CupertinoColors.systemGrey4,
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Anahtar Kelimeler',
                    style:
                        CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                  ),
                  const SizedBox(height: 8),
                  KeywordSelector(
                    isDisabled: true,
                    keywords: List<MessageKeyword>.generate(
                        widget.message.keywords.length,
                        (index) => const MessageKeyword(
                            isSelected: false, text: 'Test')),
                    onKeywordsSelected: (keywords) {},
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Oluşturulma Tarihi',
                    style:
                        CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                  ),
                  const SizedBox(height: 8),
                  Text(_formatDate(widget.message.createdAt)),
                  const SizedBox(height: 80), // Alt menü için boşluk
                ],
              ),
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
                        _currentMessage,
                        widget.message.imageUrl,
                      ),
                      child: const Icon(CupertinoIcons.share),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _currentMessage));
                        _showAlert('Mesaj kopyalandı!');
                      },
                      child: const Icon(CupertinoIcons.doc_on_doc),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
