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
                const Text("Report submitted.\nNote: This is important for further status checking\nToken:"),
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

  void _cancel() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF003893);

    return Scaffold(
      appBar: CustomAppBar(),
      body: Stack(
        children: [

          Align(
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: 0.08,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                width: double.infinity,
                child: Image.asset(
                  'assets/twoflag.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Card(
                  color: Colors.white.withOpacity(0.98),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              "Submit a Report",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: themeColor,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: "Describe the issue",
                              labelText: "Description",
                              labelStyle: TextStyle(color: Colors.grey.shade800),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: (val) => val == null || val.isEmpty
                                ? "Please enter description"
                                : null,
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _locationController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: "Location",
                              labelText: "Location",
                              labelStyle: TextStyle(color: Colors.grey.shade800),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: (val) => val == null || val.isEmpty
                                ? "Please enter the location"
                                : null,
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            "Media Attachments",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 7),
                          _selectedMedia.isNotEmpty
                              ? Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: _selectedMedia.map((file) {
                                    final isImage = file.path.endsWith('.jpg') ||
                                        file.path.endsWith('.jpeg') ||
                                        file.path.endsWith('.png');
                                    return Stack(
                                      children: [
                                        Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(9),
                                            border: Border.all(color: Colors.grey.shade300),
                                            color: Colors.grey[100],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(9),
                                            child: isImage
                                                ? Image.file(file, fit: BoxFit.cover)
                                                : const Icon(Icons.videocam, size: 40, color: Colors.grey),
                                          ),
                                        ),
                                        Positioned(
                                          top: 2,
                                          right: 2,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedMedia.remove(file);
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(30),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.3),
                                                    blurRadius: 2,
                                                  )
                                                ],
                                              ),
                                              child: const Icon(Icons.close, size: 18, color: Colors.red),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }).toList(),
                                )
                              : const Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Text("No media selected.",
                                      style: TextStyle(color: Colors.grey)),
                                ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: _pickMedia,
                            icon: const Icon(Icons.upload_file, color: Colors.white),
                            label: const Text("Upload Images/Videos"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _submitReport,
                                  child: const Text("Submit Report"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: themeColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 2,
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _cancel,
                                  child: const Text("Cancel"),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red, width: 2),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                 
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}