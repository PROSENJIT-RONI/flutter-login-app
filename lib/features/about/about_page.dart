import 'package:flutter/material.dart';

class MyAboutPage extends StatelessWidget {
  const MyAboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF3E5F5), Color(0xFFEDE7F6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 35),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purpleAccent, Colors.deepPurple],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.flutter_dash,
                      size: 45,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Flutter Login App",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Version 1.0.0",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ABOUT CARD
            _buildCard(
              title: "About This App",
              content:
                  "This application demonstrates user authentication, "
                  "OTP verification, password reset, local storage handling, "
                  "profile management, and modern navigation structure using Flutter & GetX.",
              icon: Icons.info_outline,
            ),

            const SizedBox(height: 20),

            //  DEVELOPER CARD
            _buildCard(
              title: "Developer",
              content: "Prosenjit Swarnakar\nFlutter & GetX Enthusiast",
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 20),

            // CONTACT CARD
            Card(
              elevation: 8,
              shadowColor: Colors.deepPurple.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.contact_mail, color: Colors.deepPurple),
                        SizedBox(width: 10),
                        Text(
                          "Contact Information",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.email, color: Colors.purpleAccent),
                      title: Text(
                        "prosenjitswarnakar2002@gmail.com",
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.phone, color: Colors.purpleAccent),
                      title: Text("+91 7439572661"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "© 2026 All Rights Reserved",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 8,
      shadowColor: Colors.deepPurple.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepPurple),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 10),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
