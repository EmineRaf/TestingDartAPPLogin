import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    final response = await http.post(
      Uri.parse("http://192.168.1.17:8080/api/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "email": emailController.text,
        "password": passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data["token"];
      print("Token reçu : $token");
    } else {
      print("Erreur login : ${response.body}");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Erreur de connexion"),
          content: const Text("Email ou mot de passe incorrect."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 201, 196, 196),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/logo2.png',
                    height: 180,
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    "SIGN IN",
                    style: GoogleFonts.robotoCondensed(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Welcome Back, Nice to see you Again!",
                    style: GoogleFonts.robotoCondensed(fontSize: 18.0),
                  ),
                  const SizedBox(height: 10.0),

                  // Email Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!EmailValidator.validate(value)) {
                              return 'Invalid email format';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10.0),

                  // Password Field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Validate Button
                  ElevatedButton(
                    child: const Text('Validate'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Validation Passed!')),
                        );
                        loginUser(); // Trigger login if valid
                      }
                    },
                  ),

                  const SizedBox(height: 25),

                  // Sign Up Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not a member yet?",
                        style: GoogleFonts.robotoCondensed(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // redirection vers la page de sign up
                        },
                        child: Text(
                          " Sign Up",
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
