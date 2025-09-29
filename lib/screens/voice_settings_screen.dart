import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/elevenlabs_service.dart';

class VoiceSettingsScreen extends StatefulWidget {
  final String voiceId;
  const VoiceSettingsScreen({super.key, required this.voiceId});

  @override
  State<VoiceSettingsScreen> createState() => _VoiceSettingsScreenState();
}

class _VoiceSettingsScreenState extends State<VoiceSettingsScreen> {
  bool loading = true;
  double stability = 0.5;
  double similarity = 0.5;

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  Future<void> _fetchSettings() async {
    final response =
        await ElevenLabsService.getVoiceSettings(widget.voiceId);
    if (response != null) {
      final decoded = jsonDecode(response);
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
    setState(() => loading = true);
    final success = await ElevenLabsService.updateVoiceSettings(
      widget.voiceId,
      stability,
      similarity,
    );
    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? "Settings updated successfully!"
            : "Failed to update settings"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voice Settings"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Stability Slider
                  Text("Stability: ${stability.toStringAsFixed(2)}"),
                  Slider(
                    value: stability,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    label: stability.toStringAsFixed(2),
                    onChanged: (v) => setState(() => stability = v),
                  ),
                  const SizedBox(height: 20),

                  // Similarity Boost Slider
                  Text("Similarity Boost: ${similarity.toStringAsFixed(2)}"),
                  Slider(
                    value: similarity,
                    min: 0,
                    max: 1,
                    divisions: 10,
                    label: similarity.toStringAsFixed(2),
                    onChanged: (v) => setState(() => similarity = v),
                  ),
                  const SizedBox(height: 40),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _updateSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Save Settings",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
