import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:login_app/screens/LoginScreen/loginScreen2.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = 'SplashScreen';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  late AnimationController _textController;
  late Animation<Offset> _textOffsetAnimation;
  late Animation<double> _textOpacityAnimation;

  @override
  void initState() {
    super.initState();

    // Logo Pulse (Zoom in-out doux)
    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _logoAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    // Texte Slide-up + Fade-in
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textOffsetAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _textOpacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_textController);

    // Lancer animation du texte après 300ms
    Future.delayed(const Duration(milliseconds: 300), () {
      _textController.forward();
    });

    // Après 5 secondes, transition vers Login
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(_createFancyRoute());
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Route _createFancyRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 2000),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LoginScreen2(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideAnimation =
            Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutQuart),
        );

        final scaleAnimation = Tween<double>(begin: 1.2, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOut),
        );

        return SlideTransition(
          position: slideAnimation,
          child: ScaleTransition(scale: scaleAnimation, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF345FB4),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Animated text
            SlideTransition(
              position: _textOffsetAnimation,
              child: FadeTransition(
                opacity: _textOpacityAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Pen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 70.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 2.0,
                      ),
                    ),
                    Text(
                      'Tek',
                      style: GoogleFonts.pattaya(
                        fontSize: 70.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ScaleTransition(
              scale: _logoAnimation,
              child: Image.asset(
                'images/logo5.png',
                height: 250.0,
                width: 250.0,
                color: Colors.white,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
