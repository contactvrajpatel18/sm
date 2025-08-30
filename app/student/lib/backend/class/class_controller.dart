import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:model/class/class_info_model.dart';
import 'package:model/class/class_model.dart';

import 'class_provider.dart';

class ClassController {
  final ClassProvider classProvider;
  final _classCollection = FirebaseFirestore.instance.collection('classes');

  ClassController(this.classProvider);

  Future<List<ClassModel>?> fetchAllClass() async {
    classProvider.setLoading(true);
    try {
      final snapshot = await _classCollection.get();

      if (snapshot.docs.isEmpty) {
        print("❌ No Firestore documents found in class collection");
        classProvider.setError("data not found.");
        return null;
      }

      final years = snapshot.docs
          .map((doc) => ClassModel.fromMap(doc.data()))
          .toList();

      classProvider.setClassData(years);
      // print("✅ getAllClass() : ${years}");
      return years;
    } catch (e) {
      print("🔥 Error getAllClass : $e");
      classProvider.setError("Failed to load data. Please try again.");
      return null;
    } finally {
      classProvider.setLoading(false);
    }
  }

  Future<ClassModel?> fetchClassByYear({required String year}) async {
    classProvider.setLoading(true);
    try {
      final doc = await _classCollection.doc(year).get();
      if (!doc.exists) {
        print("❌ No Firestore document found for year $year");
        classProvider.setError("data not found.");
        return null;
      }
      final yearData = ClassModel.fromMap(doc.data()!);
      classProvider.setClassData([yearData]);
      // print("✅ getClassByYear($year) : ${yearData}");
      return yearData;
    } catch (e) {
      print("🔥 Error getClassByYear : $e");
      classProvider.setError("Failed to load data. Please try again.");
      return null;
    } finally {
      classProvider.setLoading(false);
    }
  }

  Future<ClassInfo?> fetchClassByYearAndName({required String year,required String className}) async {
    classProvider.setLoading(true);
    try {
      final doc = await _classCollection.doc(year).get();

      if (!doc.exists) {
        print("❌ No Firestore document found for year $year");
        classProvider.setError("data not found.");
        return null;
      }

      final data = doc.data();
      if (data == null || !data.containsKey(className)) {
        print("❌ Class $className not found in year $year");
        classProvider.setError("data not found.");
        return null;
      }

      final classInfo = ClassInfo.fromMap(Map<String, dynamic>.from(data[className]));
      // print("✅ getClassByYearAndName($year,$className) : $classInfo");
      return classInfo;

    } catch (e) {
      print("🔥 Error getClassByYearAndName : $e");
      classProvider.setError("Failed to load data. Please try again.");
      return null;
    } finally {
      classProvider.setLoading(false);
    }
  }

}











