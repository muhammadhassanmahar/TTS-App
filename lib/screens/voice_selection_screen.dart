import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/elevenlabs_service.dart';

class VoiceSelectionScreen extends StatefulWidget {
  const VoiceSelectionScreen({super.key});

  @override
  State<VoiceSelectionScreen> createState() => _VoiceSelectionScreenState();
}

class _VoiceSelectionScreenState extends State<VoiceSelectionScreen> {
  List voices = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchVoices();
  }

  Future<void> _fetchVoices() async {
    final data = await ElevenLabsService.getVoices();
    if (data != null) {
      final decoded = jsonDecode(data);
      setState(() {
        voices = decoded['voices'] ?? [];
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Voice")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: voices.length,
              itemBuilder: (context, index) {
                final voice = voices[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.record_voice_over, color: Colors.deepPurple),
                    title: Text(voice['name'] ?? "Unknown"),
                    subtitle: Text("Category: ${voice['category'] ?? 'N/A'}"),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Selected: ${voice['name']}")),
                      );
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
    );
  }
}
