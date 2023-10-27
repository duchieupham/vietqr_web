// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterProvider with ChangeNotifier {
  // FirebaseAuth auth = FirebaseAuth.instance;
  //error handler
  bool _isPhoneErr = false;
  bool _isPasswordErr = false;
  bool _isConfirmPassErr = false;

  get phoneErr => _isPhoneErr;
  get passwordErr => _isPasswordErr;
  get confirmPassErr => _isConfirmPassErr;

  final confirmPassFocus = FocusNode();

  void updateErrs({
    required bool phoneErr,
    required bool passErr,
    required bool confirmPassErr,
  }) {
    _isPhoneErr = phoneErr;
    _isPasswordErr = passErr;
    _isConfirmPassErr = confirmPassErr;

    notifyListeners();
  }

  bool isValidValidation() {
    return !_isPhoneErr && !_isPasswordErr && !_isConfirmPassErr;
  }

  focusNodeConfirmPass(BuildContext context) {
    FocusScope.of(context).requestFocus(confirmPassFocus);
  }

  void reset() {
    _isPhoneErr = false;
    _isPasswordErr = false;
    _isConfirmPassErr = false;
    notifyListeners();
  }

  String _verificationId = '';
  // Future sendOtp(String phoneNumber) async {
  //   String phone = '';
  //   if (phoneNumber.contains('+84')) {
  //     phone = phoneNumber;
  //   } else if (phoneNumber.startsWith("0")) {
  //     phone = phoneNumber.replaceFirst("0", "+84");
  //   } else {
  //     phone = phoneNumber;
  //   }
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: phone,
  //     timeout: const Duration(seconds: 120),
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       await auth.signInWithCredential(credential);
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       debugPrint('---------verificationFailed-----------------------$e');
  //     },
  //     codeSent: (String verificationId, int? resendToken) {
  //       _verificationId = verificationId;
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //       _verificationId = verificationId;
  //       debugPrint(
  //           '---------codeAutoRetrievalTimeout-----------------------$verificationId');
  //     },
  //   );
  // }

  bool _isVerifyOTP = true;
  bool get isVerifyOTP => _isVerifyOTP;

  // Future<bool> verifyOTP(String otp) async {
  //   if (_verificationId.isEmpty) {
  //     _isVerifyOTP = false;
  //     notifyListeners();
  //   } else {
  //     try {
  //       UserCredential credential = await auth.signInWithCredential(
  //           PhoneAuthProvider.credential(
  //               verificationId: _verificationId, smsCode: otp));

  //       _isVerifyOTP = credential.user != null ? true : false;
  //       notifyListeners();
  //     } catch (e) {
  //       _isVerifyOTP = false;
  //       notifyListeners();
  //     }
  //   }
  //   return _isVerifyOTP;
  // }
}
