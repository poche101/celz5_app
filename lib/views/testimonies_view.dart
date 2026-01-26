import 'package:flutter/material.dart';
// Note the import path from inside lib/views/
import 'shared/navbar.dart';
import 'shared/footer.dart';

class TestimoniesView extends StatelessWidget {
  const TestimoniesView({super.key}); // The 'const' is required!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CelzNavbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Testimonies Page Content"),
            ),
            const CelzFooter(),
          ],
        ),
      ),
    );
  }
}
