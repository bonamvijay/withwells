import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ticket_page.dart';
import 'signup_page.dart';

class AuthorizationScreen extends StatefulWidget {
  @override
  _AuthorizationScreenState createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_handleTextFieldChanged);
    _passwordController.addListener(_handleTextFieldChanged);
  }

  void _handleTextFieldChanged() {
    setState(() {}); // Trigger a rebuild to update the button state
  }

  Future<void> _login() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      if (email.isNotEmpty && password.isNotEmpty) {
        // Sign in with email and password
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Navigate to the TicketPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketPage(userEmail: userCredential.user?.email ?? ''),
          ),
        );
      } else {
        // Handle empty email or password
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Please enter both email and password.'),
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
      // Handle login errors
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

  void _signup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
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
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              onEditingComplete: _handleEditingComplete,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              onEditingComplete: _handleEditingComplete,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text('Login'),
              onPressed: _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty ? _login : null,
            ),
            ElevatedButton(
              child: Text('Sign Up'),
              onPressed: _signup,
            ),
          ],
        ),
      ),
    );
  }

  void _handleEditingComplete() {
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      _login();
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: AuthorizationScreen(),
  ));
}
