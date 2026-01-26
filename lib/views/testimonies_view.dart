import 'package:flutter/material.dart';
import 'shared/footer.dart';

class TestimoniesView extends StatelessWidget {
  const TestimoniesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Removed CelzNavbar from here
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                // 2. Forces the content to be at least the height of the screen
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("Testimonies Page Content"),
                    ),
                    // 3. Spacer pushes the footer to the bottom of the minHeight
                    const Spacer(),
                    const CelzFooter(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
