import 'package:flutter/material.dart';
import 'shared/navbar.dart';
import 'shared/footer.dart';

// 1. The Class Name must be EXACTLY 'AboutView'
class AboutView extends StatelessWidget {
  // 2. The constructor MUST have 'const' to match main.dart
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CelzNavbar(),
      body: Center(child: Text("About CELZ5")),
      bottomNavigationBar: CelzFooter(),
    );
  }
}
