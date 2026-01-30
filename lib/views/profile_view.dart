import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

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
  bool _isUpdating = false;
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
    _initializeControllers();
    _loadPermanentImage();
  }

  void _initializeControllers() {
    userData.forEach((key, value) {
      _controllers[key] = TextEditingController(text: value);
    });
  }

  Future<void> _loadPermanentImage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? imagePath = prefs.getString('saved_profile_path');
    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  Future<void> _saveImagePermanently(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_profile_path', path);
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // --- LOGIC METHODS ---

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Matches your Navbar key

    if (mounted) {
      Navigator.of(context).pop(); // Exit ProfileView
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logged out successfully")),
      );
    }
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _handleLogout();
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave() async {
    setState(() => _isUpdating = true);

    final updatedUser = UserModel(
      title: _controllers['title']!.text,
      name: _controllers['name']!.text,
      email: _controllers['email']!.text,
      phone: _controllers['phone']!.text,
      group: _controllers['group']!.text,
      church: _controllers['church']!.text,
      cell: _controllers['cell']!.text,
    );

    final result = await _updateProfileApi(updatedUser, "YOUR_TOKEN_HERE");

    if (mounted) {
      setState(() => _isUpdating = false);

      if (result['success']) {
        setState(() {
          userData.addAll(
              updatedUser.toJson().map((k, v) => MapEntry(k, v.toString())));
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? "Update failed")),
        );
      }
    }
  }

  Future<Map<String, dynamic>> _updateProfileApi(
      UserModel user, String token) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://your-api-url.com/profile/update'));
      request.headers.addAll(
          {'Accept': 'application/json', 'Authorization': 'Bearer $token'});
      request.fields.addAll(
          user.toJson().map((key, value) => MapEntry(key, value.toString())));

      if (_imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', _imageFile!.path));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return response.statusCode == 200
          ? {'success': true, 'data': jsonDecode(response.body)}
          : {
              'success': false,
              'message': 'Server error: ${response.statusCode}'
            };
    } catch (e) {
      return {'success': false, 'message': "Connection failed: $e"};
    }
  }

  Future<void> _pickProfilePicture() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      File pickedFile = File(result.files.single.path!);
      final directory = await getApplicationDocumentsDirectory();
      final String fileName =
          'profile_pic_${DateTime.now().millisecondsSinceEpoch}.png';
      final File savedFile =
          await pickedFile.copy('${directory.path}/$fileName');

      setState(() => _imageFile = savedFile);
      await _saveImagePermanently(savedFile.path);
    }
  }

  // --- UI BUILDERS ---

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
                  const SizedBox(height: 32),
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
                  _buildLogoutButton(), // Referenced here
                  const SizedBox(height: 60),
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
      expandedHeight: 340,
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
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
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
                const SizedBox(height: 40),
                _buildAvatarStack(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "${userData['title']} ${userData['name']}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
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
            radius: 65,
            backgroundColor: const Color(0xFF1E293B),
            backgroundImage: _imageFile != null
                ? FileImage(_imageFile!) as ImageProvider
                : const NetworkImage('https://i.pravatar.cc/300'),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Material(
            color: Colors.orangeAccent,
            shape: const CircleBorder(),
            elevation: 4,
            child: InkWell(
              onTap: _pickProfilePicture,
              borderRadius: BorderRadius.circular(50),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(LucideIcons.camera, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(title.toUpperCase(),
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
              letterSpacing: 1.2)),
    );
  }

  Widget _buildSwitchTile(
      {required IconData icon,
      required String title,
      required bool value,
      required Function(bool) onChanged}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, color: const Color(0xFF0A192F), size: 22),
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
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
          padding: const EdgeInsets.symmetric(vertical: 16),
          foregroundColor: Colors.redAccent,
          backgroundColor: Colors.redAccent.withOpacity(0.08),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(LucideIcons.log_out, size: 18),
        label: const Text("Log Out Account",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ),
    );
  }

  void _showEditProfileModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: !_isUpdating,
      pageBuilder: (context, anim1, anim2) => Center(
        child: StatefulBuilder(builder: (context, setModalState) {
          return Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 500),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(24)),
            child: Material(
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Edit Profile",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(LucideIcons.x, size: 24))
                      ],
                    ),
                    const SizedBox(height: 20),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildModernField("Title", _controllers['title']!,
                                LucideIcons.contact),
                            _buildModernField("Full Name",
                                _controllers['name']!, LucideIcons.user),
                            _buildModernField("Email Address",
                                _controllers['email']!, LucideIcons.mail),
                            _buildModernField("Mobile Phone",
                                _controllers['phone']!, LucideIcons.phone),
                            const Divider(height: 32),
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
                              setModalState(() {});
                              await _handleSave();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A192F),
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
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
                                  fontSize: 16,
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
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          prefixIcon: Icon(icon, size: 18, color: const Color(0xFF0A192F)),
          filled: true,
          fillColor: const Color(0xFFF1F5F9),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildMemberCodeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.black38, borderRadius: BorderRadius.circular(20)),
      child: Text(userData['code']!,
          style: const TextStyle(
              color: Colors.orangeAccent,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1)),
    );
  }

  Widget _buildQRCodeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ]),
      child: Row(
        children: [
          const Expanded(
              child: Text("Membership Token",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
          QrImageView(data: userData['code']!, size: 60.0),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: const Color(0xFF0A192F), size: 20),
      ),
      title: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF0A192F))),
      subtitle: Text(subtitle,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
      trailing: const Icon(LucideIcons.chevron_right, size: 18),
    );
  }
}
