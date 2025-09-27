import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Demo history list
  final List<String> _history = [
    "Hello, how are you?",
    "This is ElevenLabs TTS example.",
    "Premium AI voice test!"
  ];

  void _deleteItem(int index) {
    setState(() {
      _history.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      body: _history.isEmpty
          ? const Center(child: Text("No history yet."))
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final text = _history[index];
                return Dismissible(
                  key: Key(text),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _deleteItem(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("History item deleted")),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.play_arrow, color: Colors.deepPurple),
                      title: Text(text),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Play audio for: $text")),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
