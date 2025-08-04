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
  final List<ClassHistoryEntry> classHistory;
  final Map<String, ClassRecord> classRecords;

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
    required this.classHistory,
    required this.classRecords,
  });

  factory StudentModel.fromMap( Map<String, dynamic> map) {
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
      classHistory: (map['classHistory'] as List)
          .map((e) => ClassHistoryEntry.fromMap(e))
          .toList(),
      classRecords: (map['classRecords'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, ClassRecord.fromMap(value)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'gender': gender,
      'dob': dob,
      'contact': contact,
      'parentContact': parentContact,
      'address': address,
      'profileImageUrl': profileImageUrl,
      'admissionDate': admissionDate,
      'classHistory': classHistory.map((e) => e.toMap()).toList(),
      'classRecords': classRecords.map((k, v) => MapEntry(k, v.toMap())),
    };
  }

  @override
  String toString() {
    return 'Student(id: $id, name: $name, gender: $gender, dob: $dob)';
  }
}
