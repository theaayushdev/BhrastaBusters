import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/homescreen.dart';
class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedImage;

  
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery); // Or camera

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

 
  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Report Submitted"),
          content: const Text("Thank you for reporting anonymously."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _descriptionController.clear();
                setState(() => _selectedImage = null);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report Corruption")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                "Describe the issue (no personal info needed):",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'E.g., A bribe was demanded at XYZ office...',
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please describe the issue' : null,
              ),
              const SizedBox(height: 20),

              const Text(
                "Attach photo or document (optional):",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _selectedImage != null
                  ? Image.file(_selectedImage!, height: 200)
                  : const Text("No file selected."),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload Evidence"),
              ),
              const SizedBox(height: 20),
                ElevatedButton.icon(
                onPressed: _submitReport,
                icon: const Icon(Icons.send),
                label: const Text("Submit Report"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
 ElevatedButton.icon(
  onPressed: () {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
      (route) => false,
    );
  },
  icon: const Icon(Icons.cancel),
  label: const Text("Cancel"),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
  ),
),

            
            ],
          ),
        ),
      ),
    );
  }
}
