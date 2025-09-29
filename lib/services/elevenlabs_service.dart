import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ElevenLabsService {
  static String get apiKey => dotenv.env['ELEVENLABS_API_KEY'] ?? "";
  static const String baseUrl = "https://api.elevenlabs.io/v1";
  static const String defaultVoice = "pNInz6obpgDQGcFmaJgB"; // Sample voice

  /// 🔊 Text-to-Speech
  static Future<Uint8List?> textToSpeech(String text, {String? voiceId}) async {
    try {
      final url = Uri.parse("$baseUrl/text-to-speech/${voiceId ?? defaultVoice}");
      final response = await http.post(
        url,
        headers: {
          "xi-api-key": apiKey,
          "Content-Type": "application/json",
        },
        body: jsonEncode({"text": text}),
      );
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 📃 Voices List
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

  /// 👤 User Info
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

  /// ⚙️ Get Voice Settings
  static Future<String?> getVoiceSettings(String voiceId) async {
    try {
      final url = Uri.parse("$baseUrl/voices/$voiceId/settings");
      final response = await http.get(url, headers: {"xi-api-key": apiKey});
      if (response.statusCode == 200) {
        return response.body;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 🛠️ Update Voice Settings
  static Future<bool> updateVoiceSettings(
      String voiceId, double stability, double similarity) async {
    try {
      final url = Uri.parse("$baseUrl/voices/$voiceId/settings");
      final response = await http.post(
        url,
        headers: {
          "xi-api-key": apiKey,
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "stability": stability,
          "similarity_boost": similarity,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
