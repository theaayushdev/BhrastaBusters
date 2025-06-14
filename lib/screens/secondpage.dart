import 'dart:io';
import 'package:bhrastabusters/widget/topbar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
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

  final List<String> districts = [
  "Achham", "Arghakhanchi", "Baglung", "Baitadi", "Bajhang", "Bajura", "Banke", "Bara", "Bardiya",
  "Bhaktapur", "Bhojpur", "Chitwan", "Dailekh", "Dang", "Dadeldhura", "Darchula", "Dhading", "Dhankuta",
  "Dhanusha", "Dolakha", "Dolpa", "Doti", "Eastern Rukum", "Gorkha", "Gulmi", "Humla", "Ilam",
  "Jajarkot", "Jhapa", "Jumla", "Kailali", "Kalikot", "Kanchanpur", "Kapilvastu", "Kaski", "Kathmandu",
  "Kavrepalanchok", "Khotang", "Lalitpur", "Lamjung", "Mahottari", "Makwanpur", "Manang", "Morang",
  "Mugu", "Mustang", "Myagdi", "Nawalpur", "Nuwakot", "Okhaldhunga", "Palpa", "Panchthar", "Parasi",
  "Parbat", "Parsa", "Pyuthan", "Ramechhap", "Rasuwa", "Rautahat", "Rolpa", "Rupandehi", "Salyan",
  "Sankhuwasabha", "Saptari", "Sarlahi", "Sindhuli", "Sindhupalchok", "Siraha", "Solukhumbu",
  "Sunsari", "Surkhet", "Syangja", "Tanahun", "Taplejung", "Tarai", "Terhathum", "Udayapur",
  "Western Rukum"
];

final List<String> departments = [
  "Agriculture",
  "Education",
  "Forest and Soil Conservation",
  "Health Services",
  "Hydrology and Meteorology",
  "Immigration",
  "Roads",
  "Tourism",
  "Transport Management",
  "Water Supply",
  "Nepal Electricity Authority",
  "Survey Department"
];


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
      body: Stack(
        children: [
          // Faded background image on bottom half
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

          // Main scrollable content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text(
      "Select District",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
    const SizedBox(height: 8),
    DropdownButtonFormField<String>(
      value: selectedDistrict,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        filled: true,
        fillColor: Colors.white,
      ),
      hint: const Text("Choose a district"),
      items: districts
          .map((d) => DropdownMenuItem(
                value: d,
                child: Text(d),
              ))
          .toList(),
      onChanged: (value) => setState(() => selectedDistrict = value),
    ),
    const SizedBox(height: 20),

    const Text(
      "Select Department",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
    const SizedBox(height: 8),
    DropdownButtonFormField<String>(
      value: selectedDepartment,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        filled: true,
        fillColor: Colors.white,
      ),
      hint: const Text("Choose a department"),
      items: departments
          .map((d) => DropdownMenuItem(
                value: d,
                child: Text(d),
              ))
          .toList(),
      onChanged: (value) => setState(() => selectedDepartment = value),
    ),
    const SizedBox(height: 20),

    const Text(
      "Select Date",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
    const SizedBox(height: 8),
    TextField(
      controller: _dateController,
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        hintText: "Tap to select a date",
        suffixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        filled: true,
        fillColor: Colors.white,
      ),
    ),
    const SizedBox(height: 180),
  ],
),

            ),
          ),

          // Next button positioned on bottom half
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _goToReportPage,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  backgroundColor: const Color(0xFF003893),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
