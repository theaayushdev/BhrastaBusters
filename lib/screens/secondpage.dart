import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:bhrastabusters/widget/topbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class SecondWidget extends StatefulWidget {
  final String token;

  const SecondWidget({super.key, required this.token});

  @override
  State<SecondWidget> createState() => _SecondWidgetState();
}

class _SecondWidgetState extends State<SecondWidget> {
  final List<String> districts = [
    'Bhojpur', 'Dhankuta', 'Ilam', 'Jhapa', 'Khotang', 'Morang', 'Okhaldhunga',
    'Panchthar', 'Sankhuwasabha', 'Solukhumbu', 'Sunsari', 'Taplejung',
    'Terhathum', 'Udayapur', 'Bara', 'Dhanusha', 'Mahottari', 'Parsa',
    'Rautahat', 'Saptari', 'Sarlahi', 'Siraha', 'Bhaktapur', 'Chitwan',
    'Dhading', 'Dolakha', 'Kathmandu', 'Kavrepalanchok', 'Lalitpur',
    'Makwanpur', 'Nuwakot', 'Ramechhap', 'Rasuwa', 'Sindhuli',
    'Sindhupalchok', 'Baglung', 'Gorkha', 'Kaski', 'Lamjung', 'Manang',
    'Mustang', 'Myagdi', 'Nawalpur', 'Parbat', 'Syangja', 'Tanahun',
    'Arghakhanchi', 'Banke', 'Bardiya', 'Dang', 'Eastern Rukum', 'Gulmi',
    'Kapilvastu', 'Nawalparasi West', 'Palpa', 'Parasi', 'Pyuthan', 'Rolpa',
    'Dailekh', 'Dolpa', 'Humla', 'Jajarkot', 'Jumla', 'Kalikot', 'Mugu',
    'Salyan', 'Surkhet', 'Western Rukum', 'Achham', 'Baitadi', 'Bajhang',
    'Bajura', 'Dadeldhura', 'Darchula', 'Doti', 'Kailali', 'Kanchanpur'
  ];

  final List<String> departments = [
    'Traffic', 'Electricity', 'DrinkingWater', 'NepalPolice', 'Malpot (Land Revenue)',
    'Municipality Office', 'Transport Department', 'Passport Department',
    'Immigration Office', 'Tax Office', 'Health Post', 'Education Office',
    'Forestry Office', 'District Administration Office', 'Court',
    'Telecom Services', 'Hydrology and Meteorology', 'Social Welfare',
    'Election Commission', 'Consumer Rights Office',
  ];

  final TextEditingController _dateController = TextEditingController();

  String? selectedDistrict;
  String? selectedDepartment;
  
  final ImagePicker _picker = ImagePicker();



  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }
  Future<void> submitReport()async{
    if(selectedDepartment==null||selectedDistrict==null||_dateController.text.isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")
        ),
      );
      return;
    }
    final report = {
      "department": selectedDepartment!,
      "location": selectedDistrict!,
      "date_of_corruption": _dateController.text,
 
      "token": widget.token,
      "device_id": "flutter-device-001"
    };

    final response = await http.post(
      Uri.parse("http://<your-ip>:5000/report"), // ✅ Replace with your actual IP
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(report),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Report Submitted"),
          content: Text("Token: ${result['token']}\nCredibility Score: ${result['credibility_score']}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            )
          ],
        ),
      );
    } else {
      print("Error: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit report.")),
      );
    }
  }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select Department:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedDepartment,
                isExpanded: true,
                hint: const Text('Choose a department'),
                items: departments.map((dept) {
                  return DropdownMenuItem<String>(
                    value: dept,
                    child: Text(dept),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDepartment = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Select District:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedDistrict,
                isExpanded: true,
                hint: const Text('Choose a district'),
                items: districts.map((district) {
                  return DropdownMenuItem<String>(
                    value: district,
                    child: Text(district),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDistrict = value;
                  });
                },
              ),
             
          
                
            
              const SizedBox(height: 20),
              const Text(
                'Select Date:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _dateController.text.isEmpty
                            ? 'Tap to select a date'
                            : _dateController.text,
                        style: TextStyle(
                          fontSize: 16,
                          color: _dateController.text.isEmpty ? Colors.grey : Colors.black,
                        ),
                      ),
                      const Icon(Icons.calendar_today, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Token: ${widget.token}'),
                     const SizedBox(height: 20),
              TextButton(
                onPressed: () {
               
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF003893),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Next', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
        
      ),
      
    );
  }
}
