import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authorization_screen.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signUp() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final String name = _nameController.text.trim();
      final String mobileNumber = _mobileNumberController.text.trim();
      final String confirmPassword = _confirmPasswordController.text.trim();

      if (email.isNotEmpty &&
          password.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          name.isNotEmpty) {
        if (password != confirmPassword) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('Password and confirm password do not match.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
          return;
        }

        // Check if email already exists
        bool isEmailExists = await checkIfEmailExists(email);
        if (isEmailExists) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('This email is already registered.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
          return;
        }

        // Generate unique user ID
        String userId = await generateUniqueUserId(email, mobileNumber);

        // Check if user ID already exists
        bool isUserIdExists = await checkIfUserIdExists(userId);
        if (isUserIdExists) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('This user ID already exists. Please modify the name or change the mobile number.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
          return;
        }

        // Create a new user with email and password
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Save user details to Firestore
        await FirebaseFirestore.instance.collection('users').doc(email).set({
          'name': name,
          'user id': userId,
          'email': email,
          'mobile number': mobileNumber,
          'ticket id' : '',
          'room id' : '',
          'ticket' : '',
          'datentime' : ''
          // Add additional user details here if needed
        });

        // Show success message
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('User registration successful.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Navigate back to the login page
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AuthorizationScreen()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Handle empty email, password, confirm password, or name
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Please enter email, password, confirm password, and name.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // Handle sign up errors
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(error.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<bool> checkIfEmailExists(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<String> generateUniqueUserId(String email, String mobileNumber) async {
    String userId = email.split('@')[0]; // Use email ID as the prefix

    if (mobileNumber.isNotEmpty) {
      String mobileSuffix = mobileNumber.substring(mobileNumber.length - 5);
      userId += mobileSuffix; // Append the mobile number suffix
    } else {
      String randomSuffix = _generateRandomDigits(5);
      userId += randomSuffix; // Append random numbers as suffix
    }

    bool isUserIdExists = await checkIfUserIdExists(userId);
    if (isUserIdExists) {
      // User ID already exists, generate a new one recursively
      return generateUniqueUserId(email, mobileNumber);
    }

    return userId;
  }

  Future<bool> checkIfUserIdExists(String userId) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    return documentSnapshot.exists;
  }

  String _generateRandomDigits(int length) {
    final random = Random();
    String digits = '';

    for (int i = 0; i < length; i++) {
      digits += random.nextInt(10).toString();
    }

    return digits;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _mobileNumberController,
              decoration: InputDecoration(labelText: 'Mobile Number'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Change button color here
              ),
              child: Text('Sign Up'),
              onPressed: _signUp,
            ),
            SizedBox(height: 20.0),
            TextButton(
              onPressed: () {
                // Navigate back to the login page
                Navigator.pop(context);
              },
              child: Text('Back to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
