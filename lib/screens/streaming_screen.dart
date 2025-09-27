import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/elevenlabs_service.dart';

class StreamingScreen extends StatefulWidget {
  const StreamingScreen({super.key});

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen> {
  final TextEditingController _controller = TextEditingController();
  final AudioPlayer _player = AudioPlayer();
  Timer? _debounce;
  bool _loading = false;

  String? _selectedVoiceId;

  @override
  void initState() {
    super.initState();
    _selectedVoiceId = ElevenLabsService.defaultVoice; // default
  }

  void _onTextChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      if (text.isNotEmpty) {
        _streamSpeak(text);
      }
    });
  }

  Future<void> _streamSpeak(String text) async {
    setState(() => _loading = true);
    final Uint8List? audioBytes =
        await ElevenLabsService.textToSpeech(text, voiceId: _selectedVoiceId);
    if (audioBytes != null) {
      await _player.play(BytesSource(audioBytes));
    }
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Streaming TTS"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              onChanged: _onTextChanged,
              decoration: InputDecoration(
                hintText: "Type here and listen instantly...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_loading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
