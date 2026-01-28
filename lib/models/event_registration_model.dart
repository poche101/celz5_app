class EventRegistrationModel {
  final String title;
  final String fullName;
  final String phoneNumber;
  final String emailAddress;
  final String groupName;
  final String churchName;
  final String cellName;

  EventRegistrationModel({
    required this.title,
    required this.fullName,
    required this.phoneNumber,
    required this.emailAddress,
    required this.groupName,
    required this.churchName,
    required this.cellName,
  });

  // This maps Flutter's camelCase to Laravel's snake_case requirements
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'email_address': emailAddress,
      'group_name': groupName,
      'church_name': churchName,
      'cell_name': cellName,
    };
  }
}
