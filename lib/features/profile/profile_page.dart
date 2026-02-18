import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyProfilePage extends StatefulWidget {
  final VoidCallback? onProfileUpdated;

  const MyProfilePage({super.key, this.onProfileUpdated});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  double calculateCompletion() {
    int totalFields = 7;
    int completedFields = 0;

    if (nameController.text.trim().isNotEmpty) {
      completedFields++;
    }
    if (phoneController.text.trim().isNotEmpty) {
      completedFields++;
    }
    if (emailController.text.trim().isNotEmpty) {
      completedFields++;
    }
    if (ageController.text.trim().isNotEmpty) {
      completedFields++;
    }
    if (descriptionController.text.trim().isNotEmpty) {
      completedFields++;
    }
    if (selectedGender.isNotEmpty) {
      completedFields++;
    }

    if (imagePath != null && imagePath!.isNotEmpty) completedFields++;

    return completedFields / totalFields;
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isEditing = false;

  String selectedGender = "Male";

  File? imageFile;
  String? imagePath;
  String defaultImage = "https://i.pravatar.cc/300";

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
        nameController.text = userData['name'] ?? '';
        phoneController.text = userData['phone'] ?? '';
        emailController.text = userData['email'] ?? '';
        ageController.text = userData['age'] ?? '';
        descriptionController.text = userData['description'] ?? '';

        selectedGender =
            (userData['gender'] != null &&
                userData['gender'].toString().isNotEmpty)
            ? userData['gender']
            : "Male";

        imagePath = userData['imagePath'];

        if (imagePath != null && imagePath!.isNotEmpty) {
          imageFile = File(imagePath!);
        }
      });
    }
  }

  Future<void> saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUser = prefs.getString('user');

    if (storedUser == null) {
      Get.snackbar(
        "Error",
        "No user data found",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
      return;
    }

    Map<String, dynamic> oldData = jsonDecode(storedUser);

    Map<String, dynamic> updatedData = {
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'email': emailController.text.trim(),
      'gender': selectedGender,
      'age': ageController.text.trim(),
      'description': descriptionController.text.trim(),
      'imagePath': imagePath ?? '',
      'password': oldData['password'] ?? '',
    };

    await prefs.setString('user', jsonEncode(updatedData));

    widget.onProfileUpdated?.call();

    Get.snackbar(
      "Success 🎉",
      "Profile Updated Successfully!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.black,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        imagePath = pickedFile.path;
      });
    }
  }

  void showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    bool alwaysDisabled = false,
  }) {
    final bool isFieldEnabled = alwaysDisabled ? false : isEditing;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: alwaysDisabled ? false : isEditing,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isEditing ? Colors.black87 : Colors.black,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
          filled: !isFieldEnabled,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: alwaysDisabled
              ? const Icon(Icons.lock, color: Colors.grey)
              : (!alwaysDisabled && isEditing)
              ? const Icon(Icons.edit, color: Colors.purpleAccent)
              : null,
        ),
      ),
    );
  }

  Widget buildGenderSection() {
    if (!isEditing) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          enabled: false,
          controller: TextEditingController(text: selectedGender),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            labelText: "Gender",
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          'Select Gender',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        RadioGroup<String>(
          groupValue: selectedGender,
          onChanged: (String? value) {
            setState(() {
              selectedGender = value!;
            });
          },
          child: Row(
            children: const [
              Radio<String>(value: "Male"),
              Text("Male"),
              SizedBox(width: 10),
              Radio<String>(value: "Female"),
              Text("Female"),
              SizedBox(width: 10),
              Radio<String>(value: "Other"),
              Text("Other"),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // PROFILE IMAGE
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 65,
                backgroundImage: imageFile != null
                    ? FileImage(imageFile!)
                    : NetworkImage(defaultImage) as ImageProvider,
              ),

              if (isEditing)
                GestureDetector(
                  onTap: showImagePickerOptions,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 15),

          Builder(
            builder: (context) {
              double completion = calculateCompletion();
              int percentage = (completion * 100).toInt();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Profile Completion: $percentage%",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: completion,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      completion < 0.4
                          ? Colors.red
                          : completion < 0.8
                          ? Colors.orange
                          : Colors.green,
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          buildTextField('Name', nameController),
          buildTextField('Phone', phoneController),
          buildTextField(
            'Email or Username',
            emailController,
            alwaysDisabled: true,
          ),
          buildGenderSection(),
          buildTextField('Age', ageController),
          buildTextField('Description', descriptionController, maxLines: 4),

          const SizedBox(height: 25),

          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
              ),
              onPressed: () async {
                if (isEditing) {
                  await saveUserData();
                }

                setState(() {
                  isEditing = !isEditing;
                });
              },
              child: Text(
                isEditing ? 'Save Changes' : 'Edit Profile',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
