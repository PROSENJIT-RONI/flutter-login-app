import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyForgotPass extends StatefulWidget {
  const MyForgotPass({super.key});

  @override
  State<MyForgotPass> createState() => _MyForgotPassState();
}

class _MyForgotPassState extends State<MyForgotPass> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void handleOtp() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? StoredUser = prefs.getString('user');

      if (StoredUser == null) {
        Get.snackbar(
          "Error",
          "No registered user found",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
        return;
      }

      Map<String, dynamic> userData = jsonDecode(StoredUser);

      String enteredPhone = phoneController.text.trim();
      String storedPhone = userData['phone'] ?? "";

      if (enteredPhone != storedPhone) {
        Get.snackbar(
          "Error",
          "Phone number not registered",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
        );
        return;
      }

      String generateOtp = "0000";
      Get.toNamed('/otp', arguments: generateOtp);

      Get.snackbar(
        "Success",
        "OTP sent to ${phoneController.text}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
      );
      Get.snackbar(
        "Demo OTP",
        "Your OTP is $generateOtp",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
        title: const Text(
          "Reset Your Password",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 200),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Enter your phone number to receive OTP for resetting your password.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 40),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.length != 10 ||
                      !RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Please enter a valid 10-digit phone number';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone Number',
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: handleOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Get OTP', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
