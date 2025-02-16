import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiService {
  final model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: 'AIzaSyADRAipJbD2m3WzCdRPrLW2W_-Xjlmr7wI',
    safetySettings: [
      SafetySetting(
        HarmCategory.sexuallyExplicit,
        HarmBlockThreshold.none,
      ),
      SafetySetting(
        HarmCategory.dangerousContent,
        HarmBlockThreshold.none,
      ),
      SafetySetting(
        HarmCategory.harassment,
        HarmBlockThreshold.none,
      ),
      SafetySetting(
        HarmCategory.hateSpeech,
        HarmBlockThreshold.none,
      ),
    ],
  );

  final imagenModel = GenerativeModel(
    model: 'imagen-3.0-generate-002',
    apiKey: 'AIzaSyADRAipJbD2m3WzCdRPrLW2W_-Xjlmr7wI',
  );

// Replicate API anahtarı
  static const _huggingFaceApiKey =
      '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'; // Hugging Face API anahtarı

  Future<String> generateMessage(String category, String prompt) async {
    try {
      final content = [
        Content.text('''
Birisi için özel bir mesaj oluştur.
Seçilen kategori: $category
Uzunluğu 2-3 cümle arasında olsun.
$prompt
'''),
      ];

      final response = await model.generateContent(content);
      return response.text!.trim();
    } catch (e) {
      throw 'Mesaj oluşturulurken bir hata oluştu: $e';
    }
  }

  Future<String?> generateImage(String imagePrompt) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://api-inference.huggingface.co/models/stabilityai/stable-diffusion-xl-base-1.0'),
        headers: {
          'Authorization': 'Bearer $_huggingFaceApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'inputs': imagePrompt,
          'parameters': {
            'num_inference_steps': 50,
            'guidance_scale': 7.5,
            'width': 512,
            'height': 512,
          }
        }),
      );

      if (response.statusCode == 200) {
        return base64Encode(response.bodyBytes);
      }

      print('Görsel oluşturma hatası: ${response.body}');
      return null;
    } catch (e) {
      print('Görsel oluşturma hatası: $e');
      return null;
    }
  }
}
