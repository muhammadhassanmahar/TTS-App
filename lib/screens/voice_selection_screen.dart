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
    if (!mounted) return; // ✅ safety check
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

  Future<void> _openVoiceSettings(String voiceId, String voiceName) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VoiceSettingsScreen(
          voiceId: voiceId,
          voiceName: voiceName,
        ),
      ),
    );

    if (!mounted) return; // ✅ safety check
    if (result != null && result is String) {
      Navigator.pop(context, result); // Return selected voiceId back
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Voice")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : voices.isEmpty
              ? const Center(child: Text("No voices found."))
              : ListView.builder(
                  itemCount: voices.length,
                  itemBuilder: (context, index) {
                    final voice = voices[index];
                    final voiceId = voice['voice_id'];
                    final voiceName = voice['name'] ?? "Unknown";

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.record_voice_over, color: Colors.deepPurple),
                        title: Text(
                          voiceName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Category: ${voice['category'] ?? 'N/A'}"),
                        onTap: () => _openVoiceSettings(voiceId, voiceName),
                      ),
                    );
                  },
                ),
    );
  }
}

class VoiceSettingsScreen extends StatefulWidget {
  final String voiceId;
  final String voiceName;

  const VoiceSettingsScreen({super.key, required this.voiceId, required this.voiceName});

  @override
  State<VoiceSettingsScreen> createState() => _VoiceSettingsScreenState();
}

class _VoiceSettingsScreenState extends State<VoiceSettingsScreen> {
  double stability = 0.5;
  double similarity = 0.5;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final data = await ElevenLabsService.getVoiceSettings(widget.voiceId);
    if (!mounted) return; // ✅ safety check
    if (data != null) {
      final decoded = jsonDecode(data);
      setState(() {
        stability = (decoded['stability'] ?? 0.5).toDouble();
        similarity = (decoded['similarity_boost'] ?? 0.5).toDouble();
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  }

  Future<void> _updateSettings() async {
    final success = await ElevenLabsService.updateVoiceSettings(
      widget.voiceId,
      stability,
      similarity,
    );
    if (!mounted) return; // ✅ safety check

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Voice settings updated successfully")),
      );
      Navigator.pop(context, widget.voiceId); // return selected voice
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update voice settings")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings: ${widget.voiceName}")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text("Stability"),
                  Slider(
                    value: stability,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    label: stability.toStringAsFixed(1),
                    onChanged: (val) => setState(() => stability = val),
                  ),
                  const SizedBox(height: 16),
                  const Text("Similarity Boost"),
                  Slider(
                    value: similarity,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    label: similarity.toStringAsFixed(1),
                    onChanged: (val) => setState(() => similarity = val),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _updateSettings,
                    icon: const Icon(Icons.save),
                    label: const Text("Save Settings"),
                  ),
                ],
              ),
            ),
    );
  }
}
