import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mesaj güncellendi!')),
    );
  }

  void _resetMessage() {
    setState(() {
      _messageController.text = _originalMessage;
      _currentMessage = _originalMessage;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mesaj ilk haline döndürüldü')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdited = _currentMessage != _originalMessage;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.message.category),
        actions: [
          if (isEdited)
            IconButton(
              icon: const Icon(Icons.restore),
              onPressed: _resetMessage,
              tooltip: 'İlk haline döndür',
            ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: isEdited ? _updateMessage : null,
            tooltip: isEdited ? 'Kaydet' : 'Değişiklik yok',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.message.imageUrl != null) ...[
              Card(
                clipBehavior: Clip.antiAlias,
                child: Image.memory(
                  base64Decode(widget.message.imageUrl!),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: Icon(Icons.broken_image, size: 48)),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _messageController,
                      maxLines: null,
                      onChanged: (value) {
                        setState(() {
                          _currentMessage = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Mesajınızı düzenleyin...',
                      ),
                    ),
                    if (isEdited) ...[
                      const Divider(),
                      Row(
                        children: [
                          const Icon(Icons.edit, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Düzenlendi',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                    ],
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
            Wrap(
              spacing: 8,
              children: widget.message.keywords
                  .map((keyword) => Chip(label: Text(keyword)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Oluşturulma Tarihi',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(_formatDate(widget.message.createdAt)),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'share',
            onPressed: () => _shareContent(
              _currentMessage,
              widget.message.imageUrl,
            ),
            tooltip: 'Paylaş',
            child: const Icon(Icons.share),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'copy',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _currentMessage));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mesaj kopyalandı!')),
              );
            },
            tooltip: 'Kopyala',
            child: const Icon(Icons.copy),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
