import 'package:flutter/material.dart';
import 'shared/navbar.dart';
import 'shared/footer.dart';

class BlogView extends StatelessWidget {
  const BlogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CelzNavbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 200,
              child: Center(child: Text("Church Blog & News")),
            ),
            const CelzFooter(),
          ],
        ),
      ),
    );
  }
}
