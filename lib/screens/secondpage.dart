import 'dart:io';
import 'package:bhrastabusters/widget/topbar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/report.dart';

class SecondPage extends StatefulWidget {
  final String token;
  const SecondPage({super.key, required this.token});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String? selectedDistrict;
  String? selectedDepartment;
  String? selectedDate;
  String deviceId = "";
  final TextEditingController _dateController = TextEditingController();

  final List<String> districts = [...]; // Keep your districts list
  final List<String> departments = [...]; // Keep your departments list

  @override
  void initState() {
    super.initState();
    _getDeviceId();
  }

  Future<void> _getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      setState(() {
        deviceId = info.id ?? "unknown";
      });
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      setState(() {
        deviceId = info.identifierForVendor ?? "unknown";
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = "${picked.toLocal()}".split(' ')[0];
        _dateController.text = selectedDate!;
      });
    }
  }

  void _goToReportPage() {
    if (selectedDistrict != null &&
        selectedDepartment != null &&
        selectedDate != null &&
        deviceId.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReportPage(
            token: widget.token,
            department: selectedDepartment!,
            district: selectedDistrict!,
            date: selectedDate!,
            deviceId: deviceId,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all the fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedDepartment,
              hint: const Text("Select Department"),
              items: departments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (value) => setState(() => selectedDepartment = value),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedDistrict,
              hint: const Text("Select District"),
              items: districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (value) => setState(() => selectedDistrict = value),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: const InputDecoration(
                hintText: "Select Date",
                suffixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _goToReportPage,
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
