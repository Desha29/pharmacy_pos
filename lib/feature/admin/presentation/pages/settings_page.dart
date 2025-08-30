import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Row(
        children: [
          // 🔹 Sidebar (replace with your actual Sidebar widget)
          Container(
            width: 220,
            color: Colors.blueGrey[900],
            child: const Center(
              child: Text(
                "Sidebar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          // 🔹 Main content area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Title
                  const Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Account Settings Card
                  _buildSettingsCard(
                    title: "Account Settings",
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text("Profile"),
                        subtitle: const Text("Update your personal information"),
                        trailing: ElevatedButton(
                          onPressed: () {},
                          child: const Text("Edit"),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.lock),
                        title: const Text("Change Password"),
                        subtitle: const Text("Update your account password"),
                        trailing: ElevatedButton(
                          onPressed: () {},
                          child: const Text("Change"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // App Preferences Card
                  _buildSettingsCard(
                    title: "App Preferences",
                    children: [
                      SwitchListTile(
                        value: true,
                        onChanged: (val) {},
                        title: const Text("Dark Mode"),
                        secondary: const Icon(Icons.dark_mode),
                      ),
                      const Divider(),
                      SwitchListTile(
                        value: false,
                        onChanged: (val) {},
                        title: const Text("Notifications"),
                        secondary: const Icon(Icons.notifications),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Helper for consistent card design across all admin pages
  Widget _buildSettingsCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}
