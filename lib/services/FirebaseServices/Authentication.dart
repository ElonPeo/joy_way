import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool Check_Password_Match(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  bool Check_Null_SignIn_Input(String email ,String password){
    return email.trim().isNotEmpty && password.trim().isNotEmpty;
  }

  bool Check_Null_SignUp_Input(String email ,String password, String confirmPassword){
    return email.trim().isNotEmpty && password.trim().isNotEmpty && confirmPassword.trim().isNotEmpty;
  }

  bool Check_Null_ResetPassword_Input(String email){
    return email.trim().isNotEmpty;
  }

  bool Check_Valid_Password(String password) {
    String cleaned = password.replaceAll(RegExp(r'\s+'), '');
    return cleaned.length >= 6 && cleaned.length <= 128;
  }


  bool Check_Valid_Email(String email) {
    final allowedDomains = ['@gmail.com', '@hotmail.com', '@yahoo.com', '@icloud.com'];
    for (final domain in allowedDomains) {
      if (email.toLowerCase().endsWith(domain)) {
        return true;
      }
    }
    return false;
  }


  //------------------------------------------------------------
  bool Check_Before_Sending_SignUp(String email, String password, String confirmPassword) {
    return Check_Null_SignUp_Input(email, password, confirmPassword) &&
        Check_Valid_Email(email) &&
        Check_Password_Match(password, confirmPassword);
  }
  String Validate_Input_SignUp(String email, String password, String confirmPassword) {
    if(!Check_Null_SignUp_Input(email,password,confirmPassword)){
      return 'Email, Password, and Confirm Password cannot be blank.';
    }
    if (!Check_Valid_Email(email)) {
      return 'Invalid email. Only @gmail.com, @hotmail.com, @yahoo.com, @icloud.com accepted.';
    }
    if (!Check_Valid_Password(password)) {
      return 'Password must be 6–128 characters (excluding spaces).';
    }
    if(!Check_Password_Match(password, confirmPassword)) {
      return 'Password and Confirm password do not match.';
    }
    return "Unknown error";
  }
  Future<String?> Sign_Up(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Registration failed';
    } catch (e) {
      return 'Unknown error: $e';
    }
  }

  //-----------------------------------------------------------------------------------
  bool Check_Before_Sending_SignIn(String email, String password) {
    return Check_Null_SignIn_Input(email, password ) && Check_Valid_Email(email);
  }
  String Validate_Input_SignIn(String email, String password) {
    if (!Check_Null_SignIn_Input(email, password)) {
      return 'Email and Password cannot be blank.';
    }
    if (!Check_Valid_Password(password)) {
      return 'Password must be 6–128 characters (excluding spaces).';
    }
    if (!Check_Valid_Email(email)) {
      return 'Invalid email. Only @gmail.com, @hotmail.com, @yahoo.com, @icloud.com accepted.';
    }
    return 'Validate input successful';
  }

  Future<String?> Sign_In(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Login failed';
    } catch (e) {
      return 'Unknown error: $e';
    }
  }

  //---------------------------------------------------------------------------------
  bool Check_Before_Sending_ResetPassword(String email) {
    return Check_Null_ResetPassword_Input(email) && Check_Valid_Email(email);
  }
  String Validate_Input_Reset_Password(String email) {
    if(!Check_Null_ResetPassword_Input(email)){
      return 'Email cannot be blank.';
    }
    if (!Check_Valid_Email(email)) {
      return 'Invalid email. Only @gmail.com, @hotmail.com, @yahoo.com, @icloud.com accepted.';
    }
    return "Unknown error";
  }
  Future<String?> Reset_Password(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Failed to send password reset email';
    } catch (e) {
      return 'Unknown error: $e';
    }
  }


  //---------------------------------------
  Future<void> Sign_Out() async {
    await _auth.signOut();
  }
  //---------------------------------------
  User? Get_Current_User() {
    return _auth.currentUser;
  }
  //---------------------------------------
  Future<String> Check_Network() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return "Check your network connection";
    } else {
      return "Good network connection";
    }
  }



}
