import 'package:flutter/material.dart';
// import 'package:celz5_app/views/shared/navbar.dart'; // No longer needed here
import 'package:celz5_app/views/shared/footer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const CelzNavbar(), // REMOVED
      // extendBodyBehindAppBar: true, // REMOVED - not needed without AppBar
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HERO SECTION ---
            _buildHeroSection(context),

            // --- MAIN CONTENT AREA ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              child: const Column(
                children: [
                  Text(
                    "Welcome to CELZ5",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Spreading the message of the gospel to the ends of the earth.",
                  ),
                ],
              ),
            ),

            // --- FOOTER ---
            const CelzFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/hero_bg.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "EXPERIENCE THE EXTRAORDINARY",
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A192F),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "JOIN US LIVE",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
