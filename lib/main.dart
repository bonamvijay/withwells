import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'ticket_page.dart';
import 'authorization_screen.dart';

class MyApp extends StatelessWidget {
  final String email;
  MyApp({required this.email});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/authorization',
      routes: {
        '/authorization': (context) => AuthorizationScreen(),
        '/ticket': (context) => TicketPage(userEmail: email),
      },
    );
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp(email: AutofillHints.email));
}