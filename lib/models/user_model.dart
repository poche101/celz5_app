class UserModel {
  final int? id;
  final String name;
  final String email;
  final String? phone;
  final String? profilePicture;
  final String? title;
  final String? church;
  final String? cell;
  final String? group;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profilePicture,
    this.title,
    this.church,
    this.cell,
    this.group,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      profilePicture: json['profile_picture'],
      title: json['title'],
      church: json['church'],
      cell: json['cell'],
      group: json['group'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': name, // Matches Laravel's $request->full_name
      'email': email,
      'phone': phone,
      'title': title,
      'church': church,
      'cell': cell,
      'group': group,
    };
  }
}
