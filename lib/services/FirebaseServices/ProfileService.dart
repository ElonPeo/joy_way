import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ProfileService {

  //-----------------------------------------------
  int checkValidPhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 9 || phoneNumber.length > 11) {
      return 911;
    }
    if (!RegExp(r'^(03|05|07|08|09)').hasMatch(phoneNumber)) {
      return 305;
    }
    return 1;
  }
  //------------------------------------------------
  List<String> generateSearchKeywords(String value) {
    final keywords = <String>{};
    if (value.isEmpty || value.length < 5) return [''];
    for (int i = 5; i <= value.length; i++) {
      keywords.add(value.substring(0, i));
    }
    return keywords.toList();
  }


  //------------------------------------------------
  Future<dynamic> Check_User_Exists(String uid) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .timeout(Duration(seconds: 5), onTimeout: () {
          throw Exception("Timeout when connecting to Firestore");
          });
      if (doc.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Error when getting user information: $e");
    }
  }



  // ----------------------------------------
  Future<String?> Create_User_Information({
    required String email,
    required String userId,
    String? userName,
    String? fullName,
    String? sex,
    String? story,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? placeOfBirth,
    String? currentAddress,
  }) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      Map<String, dynamic> userData = {
        'email': email,
        'userId': userId,
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (userName != null && userName.isNotEmpty) {
        final formattedUserName = '@$userName';
        userData['userName'] = formattedUserName;
        userData['searchKeywords'] = generateSearchKeywords(formattedUserName);
      }
      if (fullName != null && fullName.isNotEmpty) {
        userData['fullName'] = fullName;
      }
      if (sex != null && sex.isNotEmpty) {
        userData['sex'] = sex;
      }
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        userData['phoneNumber'] = phoneNumber;
      }
      if (dateOfBirth != null) {
        userData['dateOfBirth'] = Timestamp.fromDate(dateOfBirth);
      }
      if (placeOfBirth != null && placeOfBirth.isNotEmpty) {
        userData['placeOfBirth'] = placeOfBirth;
      }
      if (currentAddress != null && currentAddress.isNotEmpty) {
        userData['currentAddress'] = currentAddress;
      }
      await FirebaseFirestore.instance.collection('users').doc(uid).set(userData);
      return null;
    } catch (e){
      throw Exception("Error from create information: $e");
    }
  }


  //------------------------------------------------------------------------------
  Future<String?> Update_User_Information({
    String? userName,
    String? fullName,
    String? sex,
    String? story,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? placeOfBirth,
    String? currentAddress,
  }) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      Map<String, dynamic> userData = {
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (userName != null && userName.isNotEmpty) {
        final formattedUserName = '@$userName';
        userData['userName'] = formattedUserName;
        userData['searchKeywords'] = generateSearchKeywords(formattedUserName);
      }
      if (fullName != null) userData['fullName'] = fullName;
      if (story != null) userData['story'] = story;
      if (sex != null) userData['sex'] = sex;
      if (phoneNumber != null) userData['phoneNumber'] = phoneNumber;
      if (dateOfBirth != null) userData['dateOfBirth'] = Timestamp.fromDate(dateOfBirth);
      if (placeOfBirth != null) userData['placeOfBirth'] = placeOfBirth;
      if (currentAddress != null) userData['currentAddress'] = currentAddress;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userData, SetOptions(merge: true));
      return null;
    } catch (e) {
      throw Exception("Update failed: $e");
    }
  }


  Future<dynamic> Check_User_Name_Exists(String userName) async {
    try {
      String currentUid = FirebaseAuth.instance.currentUser!.uid;
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('userName', isEqualTo: '@$userName')
          .get();
      final docsExcludingCurrentUser = query.docs.where((doc) => doc.id != currentUid).toList();
      return docsExcludingCurrentUser.isNotEmpty;
    } catch (e) {
      return 'Error when checking userName existence: $e';
    }
  }


  Future<String?> Check_Information_Before_Sending(
      String? userName,
      String? phoneNumber,
      ) async {
    if (userName == null || userName.trim().isEmpty) {
      return "Username cannot be empty.";
    }
    final userNameExists = await Check_User_Name_Exists(userName);
    if (userNameExists == true) {
      return "Username already exists.";
    }
    if (userNameExists is String) {
      return userNameExists;
    }
    if (userName.trim().length < 4) {
      return "Username must be at least 4 characters.";
    }
    if (phoneNumber == null ||
        phoneNumber.trim().isEmpty ||
        !RegExp(r'^\d{10,11}$').hasMatch(phoneNumber)) {
      return "Phone number must be 10 to 11 digits.";
    }

    return null; // hợp lệ
  }



  //-------------------------------------------------
  Future<String?> Edit_Profile({
    required String uid,
    required String email,
    String? userName,
    String? fullName,
    String? sex,
    String? story,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? placeOfBirth,
    String? currentAddress,
  }) async {
    try {
      final result = await Check_User_Exists(uid);
      return result == true
          ? await Update_User_Information(
        userName: userName,
        fullName: fullName,
        sex: sex,
        story: story,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        placeOfBirth: placeOfBirth,
        currentAddress: currentAddress,
      )
          : await Create_User_Information(
        userName: userName,
        email: email,
        userId: uid,
        fullName: fullName,
        sex: sex,
        story: story,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        placeOfBirth: placeOfBirth,
        currentAddress: currentAddress,
      );
    } catch (e) {
      return e.toString();
    }
  }







  Future<List<dynamic>?> Get_User_Information(String uid) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      return [
        data['userName'],
        data['fullName'],
        data['sex'],
        data['story'],
        data['phoneNumber'],
        data['dateOfBirth'] != null
            ? (data['dateOfBirth'] as Timestamp).toDate()
            : null,
        data['placeOfBirth'],
        data['currentAddress'],
      ];
    } catch (e) {
      print('Error getting user info: $e');
      return null;
    }
  }









}