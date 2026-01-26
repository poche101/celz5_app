import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _pushNotifications = true;
  bool _darkMode = false;

  final Map<String, TextEditingController> _controllers = {};

  final Map<String, String> userData = {
    'name': 'Deacon John Doe',
    'email': 'user@celz5.org',
    'phone': '+234 800 000 0000',
    'code': 'CELZ5-9921-X',
    'group': 'Lighthouse Group',
    'church': 'Central Church',
    'cell': 'Grace Cell',
  };

  @override
  void initState() {
    super.initState();
    userData.forEach((key, value) {
      _controllers[key] = TextEditingController(text: value);
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveData() {
    setState(() {
      _controllers.forEach((key, controller) {
        userData[key] = controller.text;
      });
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildElegantHeader(),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQRCodeSection(),
                  const SizedBox(height: 32),
                  _buildSectionTitle("Account Settings"),
                  _buildSettingsCard([
                    _SettingsTile(
                      icon: LucideIcons.user,
                      title: "Personal Information",
                      subtitle: "Name, email, church details",
                      onTap: () => _showEditProfileModal(context),
                    ),
                    _SettingsTile(
                      icon: LucideIcons.shield_check,
                      title: "Security",
                      subtitle: "Change password and 2FA",
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Preferences"),
                  _buildSettingsCard([
                    _buildSwitchTile(
                      icon: LucideIcons.bell,
                      title: "Push Notifications",
                      value: _pushNotifications,
                      onChanged: (val) =>
                          setState(() => _pushNotifications = val),
                    ),
                    _buildSwitchTile(
                      icon: LucideIcons.moon,
                      title: "Dark Mode",
                      value: _darkMode,
                      onChanged: (val) => setState(() => _darkMode = val),
                    ),
                  ]),
                  const SizedBox(height: 40),
                  _buildLogoutButton(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElegantHeader() {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: const Color(0xFF1E293B),
      // Fix: Force leading icon (back arrow) to be white
      leading: const BackButton(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: -50,
                right: -50,
                child: _CircularArt(
                    color: Colors.white.withOpacity(0.05), size: 200),
              ),
              Positioned(
                bottom: 20,
                left: -30,
                child: _CircularArt(
                    color: Colors.blueAccent.withOpacity(0.1), size: 150),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  _buildAvatarStack(),
                  const SizedBox(height: 16),
                  Text(
                    userData['name']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildMemberCodeChip(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarStack() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
              color: Colors.white24, shape: BoxShape.circle),
          child: const CircleAvatar(
            radius: 55,
            backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Material(
            color: Colors.blueAccent,
            shape: const CircleBorder(),
            elevation: 4,
            clipBehavior: Clip.antiAlias, // Ensures ink ripple is circular
            child: InkWell(
              onTap: () {
                // Logic for updating profile picture
                debugPrint("Upload profile picture triggered");
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(LucideIcons.plus, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberCodeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        userData['code']!,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildQRCodeSection() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark ? Colors.white : const Color(0xFF1E293B);

    return Semantics(
      label: "Membership QR Code",
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? theme.cardColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Digital Member Pass",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Scan at church events",
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.grey.shade500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8),
                child: QrImageView(
                  data: userData['code'] ?? 'N/A',
                  version: QrVersions.auto,
                  size: 65.0,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.circle,
                    color: Color(0xFF1E293B),
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.circle,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  controller: controller,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    const Text("Personal Info",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E293B))),
                    const SizedBox(height: 24),
                    _buildModernField(
                        "Full Name", _controllers['name']!, LucideIcons.user),
                    _buildModernField("Email Address", _controllers['email']!,
                        LucideIcons.mail),
                    _buildModernField(
                        "Phone", _controllers['phone']!, LucideIcons.phone),
                    const Divider(height: 48),
                    _buildModernField(
                        "Group", _controllers['group']!, LucideIcons.users),
                    _buildModernField(
                        "Church", _controllers['church']!, LucideIcons.church),
                    _buildModernField(
                        "Cell", _controllers['cell']!, LucideIcons.layers),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _saveData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E293B),
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        elevation: 0,
                      ),
                      child: const Text("Save Changes",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernField(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20, color: const Color(0xFF1E293B)),
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.blueAccent, width: 2)),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(title.toUpperCase(),
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: Color(0xFF94A3B8),
              letterSpacing: 1.5)),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(
      {required IconData icon,
      required String title,
      required bool value,
      required Function(bool) onChanged}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1E293B)),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
      trailing: Switch.adaptive(
          value: value, activeColor: Colors.blueAccent, onChanged: onChanged),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          foregroundColor: Colors.redAccent,
          backgroundColor: Colors.redAccent.withOpacity(0.08),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        icon: const Icon(LucideIcons.log_out, size: 20),
        label: const Text("Log Out Account",
            style: TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }
}

class _CircularArt extends StatelessWidget {
  final Color color;
  final double size;
  const _CircularArt({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: const Color(0xFF1E293B), size: 20),
        ),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: Color(0xFF1E293B))),
        subtitle: Text(subtitle,
            style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500)),
        trailing: const Icon(LucideIcons.chevron_right,
            size: 18, color: Color(0xFFCBD5E1)),
      ),
    );
  }
}
