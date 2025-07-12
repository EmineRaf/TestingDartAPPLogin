import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/routes.dart';
import 'package:login_app/screens/SplashScreen/splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pentek",
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: routes,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFF345FB4),
        primaryColor: const Color(0xFF345FB4),
        textTheme: GoogleFonts.sourceCodeProTextTheme(),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(
              fontSize: 18.0,
              height: 0.5,
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.w600),
          hintStyle: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
            height: 0.5,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFA5A5A5), width: 0.7),
          ),
        ),
      ),
    );
  }
}
