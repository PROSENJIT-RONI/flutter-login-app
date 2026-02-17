import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_login/features/home/settings_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../profile/profile_page.dart';
import '../about/about_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  bool _isFabOpen = false;

  String userName = "";
  String? imagePath;

  // 🔒 FIXED CONTACT DETAILS
  final String phoneNumber = "9552465892";
  final String whatsappNumber = "919552465892"; // 91 + number
  final String emailAddress = "aaa@gmail.com";
  final String message = "Hello, I need support.";

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

      setState(() {
        userName = (userData['name'] ?? "").split(" ").first;
        imagePath = userData['imagePath'];
      });
    }
  }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Get.offAllNamed('/login');
  }

  void showLogoutDialog() {
    Get.defaultDialog(
      title: "Confirm Logout",
      middleText: "Are you sure you want to logout?",
      textCancel: "No",
      textConfirm: "Yes",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      radius: 15,
      onConfirm: () async {
        await logoutUser();
      },
    );
  }

  // ================= CONTACT FUNCTIONS =================

  Future<void> openDialer() async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(uri);
  }

  Future<void> openWhatsApp() async {
    final Uri uri =
    Uri.parse("https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(message)}");
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> openEmail() async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      query: 'subject=Support&body=$message',
    );
    await launchUrl(uri);
  }

  Future<void> openSMS() async {
    final Uri uri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      query: 'body=$message',
    );
    await launchUrl(uri);
  }

  Widget _miniFab({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return FloatingActionButton(
      heroTag: icon.toString(),
      mini: true,
      backgroundColor: color,
      onPressed: () {
        onTap();
        setState(() {
          _isFabOpen = false;
        });
      },
      child: Icon(icon),
    );
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
      _isFabOpen = false;
    });
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            icon: const Icon(Icons.logout_outlined),
            onPressed: showLogoutDialog,
          ),
        ]
            : null,
      ),

      // ================= BODY =================
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Center(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person,
                        size: 60, color: Colors.purpleAccent),
                    const SizedBox(height: 15),
                    Text(
                      "Welcome 👋 $userName",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Have a great day!",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const MySettingsPage(),
          const MyAboutPage(),
          MyProfilePage(onProfileUpdated: loadUserData),
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
                          "Welcome 👋 $userName",
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
                    onTap: showLogoutDialog,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ================= TOGGLE FAB =================
      floatingActionButton: _currentIndex == 0
          ? SizedBox(
        width: 200,
        height: 280,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            if (_isFabOpen)
              Positioned(
                bottom: 215,
                right: 0,
                child: _miniFab(
                  icon: FontAwesomeIcons.whatsapp, // WhatsApp style
                  color: Colors.green,
                  onTap: openWhatsApp,
                ),
              ),
            if (_isFabOpen)
              Positioned(
                bottom: 165,
                right: 0,
                child: _miniFab(
                  icon: Icons.message,
                  color: Colors.orange,
                  onTap: openSMS,
                ),
              ),
            if (_isFabOpen)
              Positioned(
                bottom: 115,
                right: 0,
                child: _miniFab(
                  icon: Icons.call,
                  color: Colors.blue,
                  onTap: openDialer,
                ),
              ),
            if (_isFabOpen)
              Positioned(
                bottom: 65,
                right: 0,
                child: _miniFab(
                  icon: Icons.email_sharp,
                  color: Colors.red,
                  onTap: openEmail,
                ),
              ),
            FloatingActionButton(
              backgroundColor: Colors.purpleAccent,
              child: Icon(
                _isFabOpen ? Icons.close : Icons.support_agent,
              ),
              onPressed: () {
                setState(() {
                  _isFabOpen = !_isFabOpen;
                });
              },
            ),
          ],
        ),
      )
          : null,

      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.pinkAccent,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _isFabOpen = false;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
