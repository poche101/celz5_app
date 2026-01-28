import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

// Mock UserModel - Replace with your actual model file import
class UserModel {
  final String title, name, email, phone, group, church, cell;
  UserModel({
    required this.title,
    required this.name,
    required this.email,
    required this.phone,
    required this.group,
    required this.church,
    required this.cell,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'name': name,
        'email': email,
        'phone': phone,
        'group': group,
        'church': church,
        'cell': cell,
      };
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _pushNotifications = true;
  bool _darkMode = false;
  bool _isUpdating = false; // Track loading state
  File? _imageFile;

  final Map<String, TextEditingController> _controllers = {};

  final Map<String, String> userData = {
    'title': 'Deacon',
    'name': 'John Doe',
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

  // API Call logic using Multipart for Image support
  Future<Map<String, dynamic>> _updateProfileApi(
      UserModel user, String token) async {
    try {
      // Use MultipartRequest to handle both JSON fields and the File
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://your-api-url.com/profile/update'), // Replace with ApiConstants.updateProfile
      );

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // Add text fields
      request.fields['title'] = user.title;
      request.fields['name'] = user.name;
      request.fields['email'] = user.email;
      request.fields['phone'] = user.phone;
      request.fields['group'] = user.group;
      request.fields['church'] = user.church;
      request.fields['cell'] = user.cell;

      // Add image if exists
      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image', // The key your backend expects
          _imageFile!.path,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<void> _handleSave() async {
    setState(() => _isUpdating = true);

    // Create model from current controller text
    final updatedUser = UserModel(
      title: _controllers['title']!.text,
      name: _controllers['name']!.text,
      email: _controllers['email']!.text,
      phone: _controllers['phone']!.text,
      group: _controllers['group']!.text,
      church: _controllers['church']!.text,
      cell: _controllers['cell']!.text,
    );

    // In a real app, get your token from a Provider or Secure Storage
    final result = await _updateProfileApi(updatedUser, "YOUR_SESSION_TOKEN");

    if (mounted) {
      setState(() => _isUpdating = false);
      if (result['success']) {
        // Update local UI data
        setState(() {
          userData['name'] = updatedUser.name;
          userData['title'] = updatedUser.title;
          userData['cell'] = updatedUser.cell;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Profile updated successfully!"),
              backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  Future<void> _pickProfilePicture() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _imageFile = File(result.files.single.path!);
      });
    }
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Row(
            children: [
              Icon(LucideIcons.log_out, color: Colors.redAccent),
              SizedBox(width: 12),
              Text("Sign Out", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
              "You will be signed out of your secure session. Continue?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child:
                  const Text("Sign Out", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
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
                      icon: LucideIcons.user_cog,
                      title: "Personal Information",
                      subtitle:
                          "${userData['title']} ${userData['name']}, ${userData['cell']}",
                      onTap: () => _showEditProfileModal(context),
                    ),
                    _SettingsTile(
                      icon: LucideIcons.lock_keyhole,
                      title: "Security",
                      subtitle: "2FA, Password & Privacy",
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Preferences"),
                  _buildSettingsCard([
                    _buildSwitchTile(
                      icon: LucideIcons.bell_ring,
                      title: "Push Notifications",
                      value: _pushNotifications,
                      onChanged: (val) =>
                          setState(() => _pushNotifications = val),
                    ),
                    _buildSwitchTile(
                      icon: LucideIcons.palette,
                      title: "Interface Theme",
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
      expandedHeight: 320,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: const Color(0xFF0A192F),
      leading: const BackButton(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0A192F),
                    Color(0xFF0D47A1),
                    Color(0xFF0A192F)
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                _buildAvatarStack(),
                const SizedBox(height: 16),
                Text(
                  "${userData['title']} ${userData['name']}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                _buildMemberCodeChip(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarStack() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.orangeAccent.withOpacity(0.5), width: 2),
              shape: BoxShape.circle),
          child: CircleAvatar(
            radius: 55,
            backgroundColor: const Color(0xFF1E293B),
            backgroundImage: _imageFile != null
                ? FileImage(_imageFile!) as ImageProvider
                : const NetworkImage('https://i.pravatar.cc/300'),
          ),
        ),
        Positioned(
          bottom: 2,
          right: 2,
          child: Material(
            color: Colors.orangeAccent,
            shape: const CircleBorder(),
            elevation: 6,
            child: InkWell(
              onTap: _pickProfilePicture,
              borderRadius: BorderRadius.circular(50),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(LucideIcons.camera, color: Colors.white, size: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showEditProfileModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: !_isUpdating,
      barrierLabel: "Dismiss",
      pageBuilder: (context, anim1, anim2) => Center(
        child: StatefulBuilder(// Important: updates modal state while loading
            builder: (context, setModalState) {
          return Container(
            width: 500,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 40)
              ],
            ),
            child: Material(
              borderRadius: BorderRadius.circular(32),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Edit Profile",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0A192F))),
                        if (!_isUpdating)
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(LucideIcons.x, size: 20))
                      ],
                    ),
                    const SizedBox(height: 24),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: _buildModernField(
                                        "Title",
                                        _controllers['title']!,
                                        LucideIcons.contact)),
                                const SizedBox(width: 12),
                                Expanded(
                                    flex: 5,
                                    child: _buildModernField(
                                        "Full Name",
                                        _controllers['name']!,
                                        LucideIcons.user)),
                              ],
                            ),
                            _buildModernField("Email Address",
                                _controllers['email']!, LucideIcons.mail),
                            _buildModernField("Mobile Phone",
                                _controllers['phone']!, LucideIcons.phone),
                            const Divider(),
                            _buildModernField("Church Group",
                                _controllers['group']!, LucideIcons.users),
                            _buildModernField("Church Name",
                                _controllers['church']!, LucideIcons.church),
                            _buildModernField("Cell Name",
                                _controllers['cell']!, LucideIcons.layers),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isUpdating
                          ? null
                          : () async {
                              setModalState(() {}); // Start local spinner
                              await _handleSave();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A192F),
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isUpdating
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text("Save Changes",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildModernField(
      String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
              color: Color(0xFF94A3B8), fontWeight: FontWeight.normal),
          prefixIcon: Icon(icon, size: 18, color: const Color(0xFF0A192F)),
          filled: true,
          fillColor: const Color(0xFFF1F5F9),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Colors.orangeAccent, width: 2)),
        ),
      ),
    );
  }

  Widget _buildMemberCodeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.black26, borderRadius: BorderRadius.circular(30)),
      child: Text(userData['code']!,
          style: const TextStyle(
              color: Colors.orangeAccent,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5)),
    );
  }

  Widget _buildQRCodeSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF0A192F).withOpacity(0.06),
                blurRadius: 30,
                offset: const Offset(0, 10))
          ]),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Membership Token",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        color: Color(0xFF0F172A))),
                SizedBox(height: 4),
                Text("Scan this QR code at church events for attendance.",
                    style: TextStyle(
                        color: Color(0xFF64748B), fontSize: 13, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          QrImageView(
            data: userData['code']!,
            version: QrVersions.auto,
            size: 70.0,
            eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.circle, color: Color(0xFF0A192F)),
            dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.circle,
                color: Color(0xFF0A192F)),
          ),
        ],
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
          border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(
      {required IconData icon,
      required String title,
      required bool value,
      required Function(bool) onChanged}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0A192F)),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
      trailing: Switch.adaptive(
          value: value, activeColor: Colors.orangeAccent, onChanged: onChanged),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: _showLogoutConfirmation,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          foregroundColor: Colors.redAccent,
          backgroundColor: Colors.redAccent.withOpacity(0.08),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        icon: const Icon(LucideIcons.log_out, size: 20),
        label: const Text("Log Out Account",
            style: TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
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
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(14)),
        child: Icon(icon, color: const Color(0xFF0A192F), size: 20),
      ),
      title: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: Color(0xFF0A192F))),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
      trailing: const Icon(LucideIcons.chevron_right,
          size: 18, color: Color(0xFFCBD5E1)),
    );
  }
}
