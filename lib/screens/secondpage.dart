import 'package:bhrastabusters/widget/topbar.dart';
import 'package:flutter/material.dart';

class SecondWidget extends StatelessWidget {
   SecondWidget({super.key});
  
  

  @override
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
  final List<String> department=['Traffic','Electricity','DrinkingWater','NepalPolice','Malpot (Land Revenue)','Municipality Office','Transport Department','Passport Department','Immigration Office',
  'Tax Office','Health Post','Education Office','Forestry Office','District Administration Office','Court','Telecom Services','Hydrology and Meteorology',
  'Social Welfare','Election Commission',
  'Consumer Rights Office',];
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Department:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: department,
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
          ],
        ),
      ),
    );
  }
}