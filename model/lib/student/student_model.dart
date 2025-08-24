import 'classhistory_model.dart';
import 'classrecord_model.dart';

class StudentModel {
  final String id;
  final String name;
  final String gender;
  final String dob;
  final String contact;
  final String parentContact;
  final String address;
  final String profileImageUrl;
  final String admissionDate;
  final bool isActive;

  final List<ClassHistory> classHistory;
  final Map<String, Map<String, ClassRecord>> classRecords;

  StudentModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.dob,
    required this.contact,
    required this.parentContact,
    required this.address,
    required this.profileImageUrl,
    required this.admissionDate,
    required this.isActive,
    required this.classHistory,
    required this.classRecords,
  });

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      gender: map['gender'] ?? '',
      dob: map['dob'] ?? '',
      contact: map['contact'] ?? '',
      parentContact: map['parentContact'] ?? '',
      address: map['address'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      admissionDate: map['admissionDate'] ?? '',
      isActive: map['isActive'] ?? false,
      classHistory: (map['classHistory'] as List<dynamic>? ?? [])
          .map((e) => ClassHistory.fromMap(e))
          .toList(),
      classRecords: (map['classRecords'] as Map<String, dynamic>? ?? {})
          .map((year, yearData) => MapEntry(
        year,
        (yearData as Map<String, dynamic>).map(
              (classId, record) => MapEntry(
            classId,
            ClassRecord.fromMap(record),
          ),
        ),
      )),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'dob': dob,
      'contact': contact,
      'parentContact': parentContact,
      'address': address,
      'profileImageUrl': profileImageUrl,
      'admissionDate': admissionDate,
      'isActive': isActive,
      'classHistory': classHistory.map((e) => e.toMap()).toList(),
      'classRecords': classRecords.map((year, yearData) => MapEntry(
        year,
        yearData.map((classId, record) => MapEntry(classId, record.toMap())),
      )),
    };
  }

  @override
  String toString() {
    return 'Student(id: $id, name: $name, gender: $gender, dob: $dob, '
        'contact: $contact, parentContact: $parentContact, address: $address, '
        'profileImageUrl: $profileImageUrl, admissionDate: $admissionDate, isActive: $isActive, '
        'classHistory: $classHistory, classRecords: $classRecords)';
  }
}

