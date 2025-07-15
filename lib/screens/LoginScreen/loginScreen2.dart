import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/screens/HomeScreen/home_screen.dart';

late bool _passwordVisible;

class LoginScreen2 extends StatefulWidget {
  static String routeName = 'LoginScreen';
  const LoginScreen2({super.key});

  @override
  State<LoginScreen2> createState() => _LoginScreen2State();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

final _formKey = GlobalKey<FormState>();

class _LoginScreen2State extends State<LoginScreen2> {
  Future<void> loginUser() async {
    final response = await http.post(
      Uri.parse("http://192.168.1.18:8080/api/auth/login"),
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
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Sign in Succeed"),
          content: const Text("Welcome Back"),
          backgroundColor: Colors.green,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        HomeScreen.routeName,
        (route) => false,
      );
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
  void initState() {
    super.initState();
    _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Image.asset(
                    'images/logo5.png',
                    height: 200,
                    width: 250.0,
                    color: Colors.white,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                  //const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hi ",
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 40.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Student",
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 40.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Welcome Back, Nice to see you Again!",
                    style: GoogleFonts.robotoCondensed(
                        fontSize: 18.0, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20.0,
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0 * 3),
                  topRight: Radius.circular(20.0 * 3),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 20.0),
                            buildEmailField(),
                            const SizedBox(height: 20.0),
                            buildPasswordField(),
                            const SizedBox(height: 20.0),
                            defaultButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  loginUser();
                                }
                              },
                            ),
                            const SizedBox(height: 20.0),
                            const Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                "Forgot your password?",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Color(0xFF345FB4),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      obscureText: _passwordVisible,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.visiblePassword,
      controller: passwordController,
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.w300, fontSize: 17.0),
      decoration: InputDecoration(
        labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        isDense: true,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
          icon: Icon(_passwordVisible
              ? Icons.visibility_rounded
              : Icons.visibility_off_outlined),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your password";
        }
        if (value.length < 4) {
          return 'Your password must be >3';
        }
        return null;
      },
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      textAlign: TextAlign.start,
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.w300, fontSize: 18.0),
      decoration: const InputDecoration(
          labelText: "Email",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your Email";
        }
        if (!EmailValidator.validate(value)) {
          return 'Invalid email format';
        }
        return null;
      },
    );
  }
}

class defaultButton extends StatelessWidget {
  final VoidCallback onPressed;

  const defaultButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        padding: const EdgeInsets.only(right: 20.0),
        width: double.infinity,
        height: 60.0,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6789CA), Color(0xFF345FB4)],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(0.5, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              "Sign in",
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_outlined,
              color: Colors.white,
              size: 30.0,
            )
          ],
        ),
      ),
    );
  }
}
