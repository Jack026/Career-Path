import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

// University model to hold university information
class University {
  final String name;
  final String description;
  final String imageUrl; 
  final String websiteUrl; 

  University({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.websiteUrl, 
  });
}

class RecommendationsPage extends StatefulWidget {
  final TextEditingController ageController;
  final TextEditingController genderController;
  final TextEditingController interestsController;
  final TextEditingController skillsController;
  final TextEditingController qualificationsController;
  final TextEditingController additionalInfoController;

  RecommendationsPage({
    required this.ageController,
    required this.genderController,
    required this.interestsController,
    required this.skillsController,
    required this.qualificationsController,
    required this.additionalInfoController,
  });

  @override
  _RecommendationsPageState createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  List<University> _universities = [];
  String _careerRecommendation = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fetch recommendations when the page is loaded
    _fetchAndDisplayRecommendation();
  }

  Future<void> _fetchAndDisplayRecommendation() async {
    if (widget.ageController.text.trim().isEmpty || 
        widget.genderController.text.trim().isEmpty || 
        widget.interestsController.text.trim().isEmpty || 
        widget.skillsController.text.trim().isEmpty || 
        widget.qualificationsController.text.trim().isEmpty) {
      setState(() {
        _careerRecommendation = 'Please fill in all required fields: Age, Gender, Interests, Skills, and Qualifications.';
      });
      return;
    }

    await getCareerAndUniversityRecommendation();
  }

  Future<void> getCareerAndUniversityRecommendation() async {
    setState(() {
      _isLoading = true;
    });

    // Fetch your API key securely in a real application
    String apiKey = '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';
    String age = widget.ageController.text.trim();
    String gender = widget.genderController.text.trim();
    String interests = widget.interestsController.text.trim();
    String skills = widget.skillsController.text.trim();
    String qualifications = widget.qualificationsController.text.trim();
    String additionalInfo = widget.additionalInfoController.text.trim();

    String prompt = 'Recommend a career path for a $gender $age-year-old with interests in $interests, skills in $skills, and qualifications including $qualifications. Also recommend the best universities in India and outside India separately for further studies in their field of interest keep at least 3 recommendations each. Include university names, brief descriptions, and suggest the degree.';
    if (additionalInfo.isNotEmpty) {
      prompt += ' Additional information: $additionalInfo.';
    }

    try {
      var response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
        }),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          _careerRecommendation = jsonResponse['choices'][0]['message']['content'].trim();
          _universities = _parseUniversities(jsonResponse['choices'][0]['message']['content']);
        });
      } else {
        setState(() {
          _careerRecommendation = 'Failed to get a recommendation. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _careerRecommendation = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  

  List<University> _parseUniversities(String response) {
    // TODO: Implement actual logic to parse university data from the API response.
    // For now, using dummy data
    return [
      University(
        name: 'Stanford University',
        description: 'Stanford is known for its academic strength and proximity to Silicon Valley.',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/en/4/49/Stanford_University_seal.svg', 
        websiteUrl: 'https://www.stanford.edu/', 
      ),
      University(
        name: 'Massachusetts Institute of Technology (MIT)',
        description: 'MIT is a world-renowned institution known for its cutting-edge research and innovation.',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/e/e8/MIT_logo.svg', 
        websiteUrl: 'https://www.mit.edu/', 
      ),
      University(
        name: 'Assam Down Town University (ADTU)',
        description: 'Assam Downtown University (ADTU) is a private university in Guwahati, Assam.',
        imageUrl: 'https://www.adtu.in/assets/images/adtu-logo.png', 
        websiteUrl: 'https://www.adtu.in/',
      ),
      University(
        name: 'Indian Institute of Science (IISc)',
        description: 'IISc is India\'s leading institution for advanced scientific and technological research.',
        imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/5c/IISc_Bangalore_Logo.svg', 
        websiteUrl: 'https://www.iisc.ac.in/', 
      ),
      University(
        name: 'Indian Institute of Technology Bombay (IIT Bombay)',
        description: 'IIT Bombay is among the top engineering colleges in India.',
        imageUrl: 'https://www.iitb.ac.in/en/images/iitbombay-logo.png',
        websiteUrl: 'https://www.iitb.ac.in/', 
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wants to Know??'),
        actions: [
          TextButton(
            onPressed: _fetchAndDisplayRecommendation,
            child: const Text(
              'Get It!',
              style: TextStyle(color: Color.fromARGB(255, 143, 36, 192)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_careerRecommendation.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recommendation:',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              _careerRecommendation,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      Text(
                        'Recommended Universities:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _universities.length,
                        itemBuilder: (context, index) {
                          final university = _universities[index];
                          return GestureDetector(
                            onTap: () async {
                              final url = university.websiteUrl;
                            try {
                              if (await canLaunch(url)) {
                            await launch(url);
                              } else {
                                  // Handle case where the URL can't be launched
                              print('Could not launch $url'); 
                                // Show an error message to the user (e.g., using a SnackBar)
                                }
                              } catch (e) {
                              // Handle any exceptions during launch
                            print('Error launching URL: $e');
                               // Show an error message to the user
                              }
                            },
                            child: Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    ClipOval(
                                      child: Image.network(
                                        university.imageUrl,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(Icons.error, size: 60); 
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            university.name,
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            university.description,
                                            style: TextStyle(fontSize: 14),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}