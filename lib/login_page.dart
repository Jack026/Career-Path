import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'career_form_page.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String _errorMessage = '';
  bool _isPasswordVisible = false; // To manage password visibility

  Future<void> _login() async {
    setState(() {
      _errorMessage = '';
    });
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CareerFormPage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _getFirebaseAuthErrorMessage(e);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred: $e';
      });
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CareerFormPage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = 'Google Sign-In failed: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred: $e';
      });
    }
  }

  String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      default:
        return 'Login failed: ${e.message}';
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: Colors.white,
    body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/login.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align items at the top
            children: [
              SizedBox(height: 100), // Added space at the top
              // Your existing code...
              // Added Container for profile image/logo
              Container(
                width: 119,
                height: 119.66,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/loo.png'),
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(59),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // Added space below the image
              Text(
                'CAREER PATH',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0C0C0C),
                  fontSize: 15,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  height: 0.07,
                  letterSpacing: -0.07,
                ),
              ),
              SizedBox(height: 60), // Space between text and input fields
              // Row to align the "Log in with Email" text to the left
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 111,
                  child: Text(
                    'Log in with Email',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xFF494D9C),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 0.08,
                      letterSpacing: 0.18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 9), // Added space below the new text
              // Email Container
              Container(
                width: 380,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color:  Color(0xFF8298AA), width: 1),
                borderRadius: BorderRadius.circular(16), // Fully rounded corners
              ),
            child: TextField(
                controller: _emailController,
                obscureText: !_isPasswordVisible,
                  style: TextStyle(color: Colors.black, fontSize: 11),
                  decoration: InputDecoration(
                hintText: 'email',
                hintStyle: TextStyle(
                  color: Color(0xFFC0B6B6),
                  fontSize: 11,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 0.09,
                  letterSpacing: 0.66,
                ),
               border: OutlineInputBorder( // Apply rounded corners for TextField
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none, // No internal border
              ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
          ),
              SizedBox(height: 16),
              // Password Container
              Container(
                width: 380,
                height: 38,
              decoration: BoxDecoration( // Changed from ShapeDecoration to BoxDecoration
                color: Colors.white,
                border: Border.all(color: Color(0xFF8298AA), width: 1),
                borderRadius: BorderRadius.circular(16), // Fully rounded corners
              ),
            child: TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                  style: TextStyle(color: Colors.black, fontSize: 11),
                  decoration: InputDecoration(
                hintText: 'password',
                hintStyle: TextStyle(
                  color: Color(0xFFC0B6B6),
                  fontSize: 11,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 0.09,
                  letterSpacing: 0.66,
                ),
               border: OutlineInputBorder( // Apply rounded corners for TextField
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none, // No internal border
              ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
          ),

              SizedBox(height: 5), // Space below password container
              // Show Password / Forgot text
              SizedBox(
                width: 326.37,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible; // Toggle password visibility
                        });
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      'Show Password                                                            Forgot?',
                      style: TextStyle(
                        color: Color(0xFF496D9C),
                        fontSize: 11,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 0.09,
                        letterSpacing: 0.17,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // Space below the row
              Container(
                width: 323,
                height: 47,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(1.00, 0.00),
                    end: Alignment(-1, 0),
                    colors: [Color(0xFF224CD4), Color(0xFF11276E)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  child: Text(
                    'SIGN IN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0.07,
                      letterSpacing: 0.77,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Container(
                width: 323,
                height: 47,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(1.00, 0.00),
                    end: Alignment(-1, 0),
                    colors: [Color(0xFF97AEF9), Color(0xFFBFCBF4)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: _loginWithGoogle,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/google.png',
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 16),
                      Text(
                        'Continue with Google',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF151515),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 170,),
              Text.rich(
                TextSpan(
                  children: [
                  TextSpan(
                  text: 'by logging in, you agree to the\n',
                 style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                    height: 0.08,
                    letterSpacing: 0.71,
                ),
            ),
            TextSpan(
                text: 'Privacy Policy & Terms of Service',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 3,
                    letterSpacing: 0.71,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
              Spacer(),
              TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationPage()),
    );
  },
  child: Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: 'not a member?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w300,
            height: 0.08,
            letterSpacing: 0.66,
          ),
        ),
        TextSpan(
          text: ' Sign up now',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 0.08,
            letterSpacing: 0.66,
          ),
        ),
      ],
    ),
    textAlign: TextAlign.center,
  ),
),



              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
}
