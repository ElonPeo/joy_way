import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool checkPasswordMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  bool checkNullSignInInput(String email ,String password){
    return email.trim().isNotEmpty && password.trim().isNotEmpty;
  }

  bool checkNullSignUpInput(String email ,String password, String confirmPassword){
    return email.trim().isNotEmpty && password.trim().isNotEmpty && confirmPassword.trim().isNotEmpty;
  }

  bool checkNullResetPasswordInput(String email){
    return email.trim().isNotEmpty;
  }

  bool checkValidEmail(String email) {
    final allowedDomains = ['@gmail.com', '@hotmail.com', '@abc.com'];
    for (final domain in allowedDomains) {
      if (email.toLowerCase().endsWith(domain)) {
        return true;
      }
    }
    return false;
  }


  //------------------------------------------------------------
  bool checkBeforeSendingSignUp(String email, String password, String confirmPassword) {
    return checkNullSignUpInput(email, password, confirmPassword) &&
        checkValidEmail(email) &&
        checkPasswordMatch(password, confirmPassword);
  }
  String validateInputSignUp(String email, String password, String confirmPassword) {
    if(!checkNullSignUpInput(email,password,confirmPassword)){
      return 'Email, Password, and Confirm Password cannot be blank.';
    }
    if (!checkValidEmail(email)) {
      return 'Invalid email. Only @gmail.com, @hotmail.com, @abc.com accepted.';
    }
    if(!checkPasswordMatch(password, confirmPassword)) {
      return 'Password and Confirm password do not match.';
    }
    return "Unknown error";
  }
  Future<String?> signUp(String email, String password) async {
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
  bool checkBeforeSendingSignIn(String email, String password) {
    return checkNullSignInInput(email, password ) && checkValidEmail(email);
  }
  String validateInputSignIn(String email, String password) {
    if(!checkNullSignInInput(email, password)){
      return 'Email and Password cannot be blank.';
    }
    if (!checkValidEmail(email)) {
      return 'Invalid email. Only @gmail.com, @hotmail.com, @abc.com accepted.';
    }
    return "Unknown error";
  }
  Future<String?> signIn(String email, String password) async {
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
  bool checkBeforeSendingResetPassword(String email) {
    return checkNullResetPasswordInput(email) && checkValidEmail(email);
  }
  String validateInputResetPassWord(String email) {
    if(!checkNullResetPasswordInput(email)){
      return 'Email cannot be blank.';
    }
    if (!checkValidEmail(email)) {
      return 'Invalid email. Only @gmail.com, @hotmail.com, @abc.com accepted.';
    }
    return "Unknown error";
  }
  Future<String?> resetPassword(String email) async {
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
  Future<void> signOut() async {
    await _auth.signOut();
  }
  //---------------------------------------
  User? getCurrentUser() {
    return _auth.currentUser;
  }
  //---------------------------------------
  Future<String> checkNetwork() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return "Check your network connection";
    } else {
      return "Good network connection";
    }
  }
}
