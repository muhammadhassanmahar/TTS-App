import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ElevenLabsService {
  static const String apiKey = "sk_f8503ec28746e443b6df5ea0dda634dae1cfe50aaa0b5c50";
  static const String baseUrl = "https://api.elevenlabs.io/v1";
  static const String defaultVoice = "pNInz6obpgDQGcFmaJgB"; // Ek sample voice

  /// Text-to-Speech
  static Future<Uint8List?> textToSpeech(String text, {String? voiceId}) async {
    try {
      final url = Uri.parse("$baseUrl/text-to-speech/${voiceId ?? defaultVoice}");
      final response = await http.post(
        url,
        headers: {
          "xi-api-key": apiKey,
          "Content-Type": "application/json",
        },
        body: '{"text": "$text"}',
      );
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Voices List
  static Future<String?> getVoices() async {
    try {
      final url = Uri.parse("$baseUrl/voices");
      final response = await http.get(url, headers: {"xi-api-key": apiKey});
      if (response.statusCode == 200) {
        return response.body;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// User Info
  static Future<String?> getUserInfo() async {
    try {
      final url = Uri.parse("$baseUrl/user");
      final response = await http.get(url, headers: {"xi-api-key": apiKey});
      if (response.statusCode == 200) {
        return response.body;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
