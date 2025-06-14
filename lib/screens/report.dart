import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'homescreen.dart';
import '../widget/topbar.dart';
import 'package:flutter/services.dart';

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
  final TextEditingController _locationController = TextEditingController();
  
  List<File> _selectedMedia = [];

  // ✅ Replaces old _pickImage
  Future<void> _pickMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'webm'],
    );

    if (result != null) {
      setState(() {
        _selectedMedia = result.paths.map((p) => File(p!)).toList();
      });
    }
  }

    Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      final uri = Uri.parse("http://172.16.3.155:5000/report");
      var request = http.MultipartRequest('POST', uri);

      request.fields['department'] = widget.department;
      request.fields['district'] = widget.district;
      request.fields['location'] = _locationController.text;
      request.fields['date'] = widget.date;
      request.fields['description'] = _descriptionController.text;
      request.fields['device_id'] = widget.deviceId;

      for (var file in _selectedMedia) {
        request.files.add(
          await http.MultipartFile.fromPath('media', file.path),
        );
      }

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        final generatedToken = data['token'];

        Clipboard.setData(ClipboardData(text: generatedToken));

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Success"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Report submitted.\nNote :This is important for further status checking\nToken:"),
                const SizedBox(height: 8),
                SelectableText(
                  generatedToken,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text("Token copied to clipboard."),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => HomePage()),
                    (route) => false,
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
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: CustomAppBar(),
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
              TextFormField(
                controller: _locationController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: "Location",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Please enter the location" : null,
              ),
              const SizedBox(height: 16),

              // ✅ Preview media files
              if (_selectedMedia.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: _selectedMedia.map((file) {
                    final isImage = file.path.endsWith('.jpg') || file.path.endsWith('.jpeg') || file.path.endsWith('.png');
                    return Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: isImage
                          ? Image.file(file, fit: BoxFit.cover)
                          : const Icon(Icons.videocam, size: 50),
                    );
                  }).toList(),
                )
              else
                const Text("No media selected."),

              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _pickMedia,
                icon: const Icon(Icons.upload_file),
                label: const Text("Upload Images/Videos"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitReport,
                child: const Text("Submit Report"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
