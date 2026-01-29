import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class CelzMobileDrawer extends StatelessWidget {
  final Function(int) onItemSelected;
  final int currentIndex;

  const CelzMobileDrawer(
      {super.key, required this.onItemSelected, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            const DrawerHeader(
                child: Center(
                    child: Text("CELZ5",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)))),
            _tile(LucideIcons.house, "Home", 0, context),
            _tile(LucideIcons.info, "About Us", 1, context),
            _tile(LucideIcons.megaphone, "Testimony", 2, context),
            _tile(LucideIcons.calendar_check, "Events", 3, context),
            // ... add the rest of your items here
          ],
        ),
      ),
    );
  }

  Widget _tile(IconData icon, String label, int index, BuildContext context) {
    bool isSelected = currentIndex == index;
    return ListTile(
      leading:
          Icon(icon, color: isSelected ? Colors.orangeAccent : Colors.black),
      title: Text(label,
          style: TextStyle(
              color: isSelected ? Colors.orangeAccent : Colors.black)),
      onTap: () {
        Navigator.pop(context);
        onItemSelected(index);
      },
    );
  }
}
