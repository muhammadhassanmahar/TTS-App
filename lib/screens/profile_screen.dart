import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/elevenlabs_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userInfo;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final data = await ElevenLabsService.getUserInfo();
    if (data != null) {
      setState(() {
        userInfo = jsonDecode(data);
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : userInfo == null
              ? const Center(child: Text("Failed to load user info"))
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.deepPurple,
                            child: Icon(Icons.person, size: 60, color: Colors.white),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            userInfo!['subscription']?['user_id'] ?? "Unknown User",
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Plan: ${userInfo!['subscription']?['tier'] ?? 'Free'}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    _buildInfoTile("Character Limit", "${userInfo!['subscription']?['character_limit'] ?? 'N/A'}"),
                    _buildInfoTile("Used Characters", "${userInfo!['subscription']?['character_count'] ?? '0'}"),
                    _buildInfoTile("Next Reset", userInfo!['subscription']?['next_character_count_reset_unix']?.toString() ?? "N/A"),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text("Logout"),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Logout tapped")),
                        );
                      },
                    ),
                  ],
                ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
