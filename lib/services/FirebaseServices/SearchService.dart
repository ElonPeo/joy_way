import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  Future<List<Map<String, dynamic>>> Find_Users({required String keyword}) async {
    try {
      final collection = FirebaseFirestore.instance.collection('users');
      if (keyword.length == 28) {
        final query = await collection
            .where('userId', isEqualTo: keyword)
            .limit(10)
            .get();
        return query.docs.map((doc) => {
          'uid': doc.id,
          ...doc.data() as Map<String, dynamic>,
        }).toList();
      }
      if (keyword.length >= 5 || keyword.startsWith('@')) {
        final query = await collection
            .where('searchKeywords', arrayContains: keyword)
            .limit(10)
            .get();
        return query.docs.map((doc) => {
          'uid': doc.id,
          ...doc.data() as Map<String, dynamic>,
        }).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error finding users: $e');
    }
  }
}
