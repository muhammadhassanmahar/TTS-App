import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double stability = 0.5;
  double similarity = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Voice Settings")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Adjust Voice Settings",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Stability
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Stability"),
                        Text(stability.toStringAsFixed(2)),
                      ],
                    ),
                    Slider(
                      value: stability,
                      onChanged: (val) => setState(() => stability = val),
                      min: 0,
                      max: 1,
                      divisions: 10,
                      activeColor: Colors.deepPurple,
                    ),
                  ],
                ),
              ),
            ),

            // Similarity
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Similarity Boost"),
                        Text(similarity.toStringAsFixed(2)),
                      ],
                    ),
                    Slider(
                      value: similarity,
                      onChanged: (val) => setState(() => similarity = val),
                      min: 0,
                      max: 1,
                      divisions: 10,
                      activeColor: Colors.deepPurple,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Settings applied:\nStability=$stability, Similarity=$similarity",
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text("Save Settings"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
