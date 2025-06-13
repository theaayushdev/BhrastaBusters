import 'dart:io';
import 'package:bhrastabusters/widget/topbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SecondWidget extends StatefulWidget {
  final String token; // ✅ ADDED: token parameter

  const SecondWidget({super.key, required this.token}); // ✅ UPDATED constructor

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

  String? selectedDistrict;
  String? selectedDepartment;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // ✅ Allow scrolling if needed
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
                hint: const Text('Choose a department'), // ✅ fixed label
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
                hint: const Text('Choose a district'), // ✅ fixed label
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
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_outlined,
                                size: 50, color: Colors.grey[600]),
                            const SizedBox(height: 10),
                            Text(
                              'Tap to select an image',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 16),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Token: ${widget.token}'), 
            ],
          ),
        ),
      ),
    );
  }
}
