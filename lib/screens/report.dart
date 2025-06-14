
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'homescreen.dart';

class ReportPage extends StatefulWidget {
  final String token;
  final String department;
  final String district;
  final String date;
  final String deviceId;

  const ReportPage({
    super.key,
    required this.token,
    required this.department,
    required this.district,
    required this.date,
    required this.deviceId,
  });

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _submitReport() async {
  if (_formKey.currentState!.validate()) {
    final uri = Uri.parse("http://172.16.3.155:5000/report");
    var request = http.MultipartRequest('POST', uri);

    request.fields['department'] = widget.department;
    request.fields['location'] = widget.district;
    request.fields['date'] = widget.date;
    request.fields['description'] = _descriptionController.text;
    request.fields['device_id'] = widget.deviceId;

    if (_selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath('media', _selectedImage!.path));
    }

    var response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Success"),
          content: Text("Report submitted.\nToken: ${data['token']}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => HomePage()),
                  (route) => false, // Remove all previous routes
                );
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit: ${response.statusCode}")),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Final Step: Submit Report")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: "Describe the issue",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Please enter description" : null,
              ),
              const SizedBox(height: 16),
              _selectedImage != null
                  ? Image.file(_selectedImage!)
                  : const Text("No image selected."),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.upload),
                label: const Text("Upload Image"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitReport,
                child: const Text("Submit Report"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
