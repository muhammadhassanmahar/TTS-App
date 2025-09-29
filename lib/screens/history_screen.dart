import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Demo static history list
  final List<String> _history = [
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
      appBar: AppBar(
        title: const Text(
          "History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _history.isEmpty
          ? const Center(
              child: Text(
                "No history yet.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _history.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final text = _history[index];
                return Dismissible(
                  key: Key(text),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _deleteItem(index);
                    if (!mounted) return; // ✅ safety for context
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("History item deleted")),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          // ✅ Fixed deprecated withOpacity
                          color: Colors.deepPurple.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.play_arrow,
                            color: Colors.deepPurple),
                      ),
                      title: Text(
                        text,
                        style: const TextStyle(fontSize: 15),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        if (!mounted) return; // ✅ safety
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
