import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import 'profile_page.dart'; // Make sure you have this file defined
import 'recommendations_page.dart'; // Make sure you have this file defined

void main() {
  runApp(CareerRecommendationApp());
}

class CareerRecommendationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Career Recommendation',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          headlineMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 18.0),
        ),
      ),
      home: CareerFormPage(),
    );
  }
}

class CareerFormPage extends StatefulWidget {
  const CareerFormPage({Key? key}) : super(key: key);

  @override
  _CareerFormPageState createState() => _CareerFormPageState();
}

class _CareerFormPageState extends State<CareerFormPage> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController interestsController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController qualificationsController = TextEditingController();
  final TextEditingController additionalInfoController = TextEditingController();

  int _selectedIndex = 0;
  String? _selectedGender;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Career Recommendation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 13, 140, 243),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 13, 140, 243),
                Color.fromARGB(255, 0, 84, 216),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('About'),
                    content: Text(
                        'This app helps you find a career path based on your interests, skills, and qualifications. Powered by HackaBytes.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.info_outline),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildCareerFormBody(),
          RecommendationsPage(
            ageController: ageController,
            genderController: genderController,
            interestsController: interestsController,
            skillsController: skillsController,
            qualificationsController: qualificationsController,
            additionalInfoController: additionalInfoController,
          ),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.recommend), label: 'Recommendations'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildCareerFormBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Tell us About you:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            _buildInputField(
              labelText: 'Age',
              controller: ageController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            _buildDropdownField(
              labelText: 'Gender',
              value: _selectedGender,
              onChanged: (newValue) {
                setState(() {
                  _selectedGender = newValue;
                  genderController.text = newValue!;  // Update the controller directly
                });
              },
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Your Interests, Skills, and Qualifications:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            _buildInputField(labelText: 'Interests', controller: interestsController),
            SizedBox(height: 16),
            _buildInputField(labelText: 'Skills', controller: skillsController),
            SizedBox(height: 16),
            _buildInputField(labelText: 'Qualifications', controller: qualificationsController),
            SizedBox(height: 16),
            _buildInputField(
              labelText: 'Additional Information (Optional)',
              controller: additionalInfoController,
            ),
            SizedBox(height: 48),
            Center(
  child: ElevatedButton(
    onPressed: () {
      if (ageController.text.isEmpty ||
          _selectedGender == null ||
          interestsController.text.isEmpty ||
          skillsController.text.isEmpty ||
          qualificationsController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please fill in all required fields: Age, Gender, Interests, Skills, and Qualifications.',
            ),
          ),
        );
        return;
      }

      // Set the gender controller text from the selected dropdown value
      genderController.text = _selectedGender!; 

      setState(() {
        _selectedIndex = 1; // Navigate to Recommendations page
      });
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
      textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
    child: Text(
      'Get Recommendation',
      style: TextStyle(color: Colors.white),
    ),
  ),
),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String labelText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String labelText,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: ['Male', 'Female', 'LGBTQ++'].map((String gender) {
        return DropdownMenuItem<String>(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
    );
  }
}
