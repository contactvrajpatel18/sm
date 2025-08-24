class TeacherModel {
  final String id;
  final String name;
  final String gender;
  final String dob;
  final String contact;
  final String email;
  final List<String> subjects;
  final Map<String, List<String>> assignedClasses; // year → list of classIds
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

  factory TeacherModel.fromMap(Map<String, dynamic> map) {
    return TeacherModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      gender: map['gender'] ?? '',
      dob: map['dob'] ?? '',
      contact: map['contact'] ?? '',
      email: map['email'] ?? '',
      subjects: List<String>.from(map['subjects'] ?? []),
      assignedClasses: (map['assignedClasses'] as Map<String, dynamic>? ?? {})
          .map((year, classes) =>
          MapEntry(year, List<String>.from(classes as List<dynamic>))),
      joiningDate: map['joiningDate'] ?? '',
      isActive: map['isActive'] ?? false,
      profileImageUrl: map['profileImageUrl'] ?? '',
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
    return 'Teacher(id: $id, name: $name, gender: $gender, dob: $dob, '
        'contact: $contact, email: $email, subjects: $subjects, '
        'assignedClasses: $assignedClasses, joiningDate: $joiningDate, '
        'isActive: $isActive, profileImageUrl: $profileImageUrl)';
  }
}
