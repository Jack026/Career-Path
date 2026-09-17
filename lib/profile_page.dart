import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
           children: [
  CircleAvatar(
    radius: 45,
    child: Icon(
      Icons.person,
      size: 50,
    ),
  ),
  SizedBox(height: 20),
  Text(
    'User Profile',
    style: Theme.of(context).textTheme.headlineMedium,
  ),
  SizedBox(height: 20),
            SizedBox(height: 20),
            if (user != null) ...[
              Text('Name: ${user.displayName ?? 'N/A'}'),
              Text('Email: ${user.email ?? 'N/A'}'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('Logout'),
              ),
            ] else
              Text('Please log in to see your profile.'),
          ],
        ),
      ),
    );
  }
}