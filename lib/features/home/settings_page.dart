import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySettingsPage extends StatefulWidget {
  const MySettingsPage({super.key});

  @override
  State<MySettingsPage> createState() => _MySettingsPageState();
}

class _MySettingsPageState extends State<MySettingsPage> {
  bool isDarkMode = false;
  bool isNotificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
      isNotificationsEnabled =
          prefs.getBool('isNotificationsEnabled') ?? true;
    });
  }

  Future<void> saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isDarkMode', isDarkMode);
    await prefs.setBool('isNotificationsEnabled', isNotificationsEnabled);

    Get.snackbar(
      'Success',
      'Settings Saved Successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: const Icon(Icons.lock, color: Colors.black),
              title: const Text(
                'Change Password',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Get.toNamed('/changepassword');
              },
            ),
          ),

          const SizedBox(height: 20),


          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  secondary: const Icon(Icons.dark_mode),
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                  },
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Notifications'),
                  secondary: const Icon(Icons.notifications),
                  value: isNotificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      isNotificationsEnabled = value;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),


          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
