class TeacherModel {
  final String id;
  final String name;
  final String gender;
  final String dob;
  final String contact;
  final String email;
  final List<String> subjects;
  final List<String> assignedClasses;
  final String joiningDate;
  final bool isActive;
  final String profileImageUrl;

  TeacherModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.dob,
    required this.contact,
    required this.email,
    required this.subjects,
    required this.assignedClasses,
    required this.joiningDate,
    required this.isActive,
    required this.profileImageUrl,
  });

  factory TeacherModel.fromMap(Map<String, dynamic> data) {
    return TeacherModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      gender: data['gender'] ?? '',
      dob: data['dob'] ?? '',
      contact: data['contact'] ?? '',
      email: data['email'] ?? '',
      subjects: List<String>.from(data['subjects'] ?? []),
      assignedClasses: List<String>.from(data['assignedClasses'] ?? []),
      joiningDate: data['joiningDate'] ?? '',
      isActive: data['isActive'] ?? false,
      profileImageUrl: data['profileImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'dob': dob,
      'contact': contact,
      'email': email,
      'subjects': subjects,
      'assignedClasses': assignedClasses,
      'joiningDate': joiningDate,
      'isActive': isActive,
      'profileImageUrl': profileImageUrl,
    };
  }
  @override
  String toString() {
    return 'Teacher(id: $id, name: $name, gender: $gender, subjects: $subjects, assignedClasses: $assignedClasses)';
  }

}
