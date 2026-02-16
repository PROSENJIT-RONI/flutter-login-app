import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;

  const OtpInput({
    super.key,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 55,
      child: TextField(
        controller: controller,
        autofocus: autoFocus,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }

          if (value.isEmpty) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {

  late String receivedOtp;


  final _fieldOne = FocusNode();
  final _fieldTwo = FocusNode();
  final _fieldThree = FocusNode();
  final _fieldFour = FocusNode();

  // Controllers
  final TextEditingController _controllerOne = TextEditingController();
  final TextEditingController _controllerTwo = TextEditingController();
  final TextEditingController _controllerThree = TextEditingController();
  final TextEditingController _controllerFour = TextEditingController();

  @override
  void initState() {
    super.initState();


    receivedOtp = Get.arguments ?? "";

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Get.snackbar(
    //       "Demo OTP",
    //       "Your OTP is $receivedOtp",
    //       snackPosition: SnackPosition.TOP,
    //       backgroundColor: Colors.red.shade100,
    //     );
    //     Get.back();
    // });
  }

  @override
  void dispose() {
    _fieldOne.dispose();
    _fieldTwo.dispose();
    _fieldThree.dispose();
    _fieldFour.dispose();

    _controllerOne.dispose();
    _controllerTwo.dispose();
    _controllerThree.dispose();
    _controllerFour.dispose();

    super.dispose();
  }

  void _verifyOtp() {
    String otp =
        _controllerOne.text +
        _controllerTwo.text +
        _controllerThree.text +
        _controllerFour.text;

    if (otp.length == 4) {
      if (otp == receivedOtp) {
        Get.snackbar(
          "Success",
          "OTP Verified Successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade100,
        );

        Get.toNamed('/changepassword');
      } else {
        Get.snackbar(
          "Error",
          "Invalid OTP. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Please enter complete OTP",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter the OTP sent to your mobile number',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OtpInput(
                  controller: _controllerOne,
                  focusNode: _fieldOne,
                  nextFocusNode: _fieldTwo,
                  autoFocus: true,
                ),
                OtpInput(
                  controller: _controllerTwo,
                  focusNode: _fieldTwo,
                  nextFocusNode: _fieldThree,
                ),
                OtpInput(
                  controller: _controllerThree,
                  focusNode: _fieldThree,
                  nextFocusNode: _fieldFour,
                ),
                OtpInput(controller: _controllerFour, focusNode: _fieldFour),
              ],
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: _verifyOtp,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                child: const Text(
                  'Verify',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade100,
                  foregroundColor: Colors.black87,
                ),
                onPressed: () {
                  Get.snackbar(
                    "Info",
                    "Verification code resent",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: const Text(
                  'Resend Code',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
