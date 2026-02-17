import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_login/features/home/settings_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../profile/profile_page.dart';
import '../about/about_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  String userName = "";
  String? imagePath;

  final List<String> _titles = ["Home", "Settings", "About", "Profile"];

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUser = prefs.getString('user');

    if (storedUser != null) {
      Map<String, dynamic> userData = jsonDecode(storedUser);
      String fullName = userData['name'] ?? "";

      setState(() {
        userName = fullName.split(" ").first;
        imagePath = userData['imagePath'];
      });
    }
  }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Get.offAllNamed('/login');
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 3
          ? null
          : AppBar(
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
        title: Text(
          _titles[_currentIndex],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: _currentIndex == 0
            ? [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await logoutUser();
              Get.snackbar(
                "Success",
                "Logged out successfully",
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ]
            : null,
      ),

      // ================= BODY =================
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Center(
            child: Text(
              "Welcome 👋 $userName!",
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const MySettingsPage(),
          const MyAboutPage(),
          const MyProfilePage(),
        ],
      ),

      // ================= DRAWER =================
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purpleAccent,
                          Colors.deepPurpleAccent
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage:
                          (imagePath != null && imagePath!.isNotEmpty)
                              ? FileImage(File(imagePath!))
                              : null,
                          child: (imagePath == null || imagePath!.isEmpty)
                              ? const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.purpleAccent,
                          )
                              : null,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          userName.isNotEmpty
                              ? "Welcome 👋 $userName"
                              : "Welcome 👋 User",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text("Home"),
                    onTap: () => _changeTab(0),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text("Settings"),
                    onTap: () => _changeTab(1),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text("About"),
                    onTap: () => _changeTab(2),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Profile"),
                    onTap: () => _changeTab(3),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text("Logout"),
                    onTap: () async {
                      await logoutUser();
                      Get.snackbar(
                        "Success",
                        "Logged out successfully",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                ],
              ),
            ),

            // ================= FOOTER =================
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 18, horizontal: 63),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: const Border(
                  top: BorderSide(color: Colors.grey),
                ),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flutter_dash,
                      size: 36, color: Colors.blue),
                  SizedBox(height: 6),
                  Text(
                    "Flutter Login App",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Version 1.0.0",
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "© 2026 Developed by Prosenjit",
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.pinkAccent,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(
              icon: Icon(Icons.info), label: "About"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}


