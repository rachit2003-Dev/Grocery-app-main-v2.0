import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/location_provider.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/otp_screen.dart';
import 'package:flutter_app/services/user_services.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String smsOtp = "";
  String verificationId = "";
  String error = "";
  final UserServices _userServices = UserServices();
  bool loading =false;
  LocationProvider locationData = LocationProvider();

  Future<UserCredential?> signInWithCredential(PhoneAuthCredential credential) async {
    return await _auth.signInWithCredential(credential);
  }
  Future<void> verifyPhone({BuildContext? context, String? number, double? latitude, double? longitude, String? address}) async {
    this.loading=true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      this.loading=false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      this.loading=false;
      print(e.code);
      this.error=e.toString();
      notifyListeners();
    };

    final PhoneCodeSent smsOtpSend = (String verId, [int? resendToken]) async {
      this.verificationId = verId;
      // Navigate to OTPScreen
      Navigator.push(
        context!,
        MaterialPageRoute(
          builder: (context) => OTPScreen(phoneNumber: number!),
        ),
      );
    };

    try {
      _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsOtpSend,
        codeAutoRetrievalTimeout: (String verId) {
          this.verificationId = verId;
        },
      );
    } catch (e) {
      this.error=e.toString();
      notifyListeners();
      print(e);
    }
  }


  void createUser({String? id, String? number, double? latitude, double? longitude, String? address}) {
    _userServices.createUserData({
      'id': id,
      'number': number,
      'latitude':latitude,
      'longitude':longitude,
      'address': address,
    });
    this.loading=false;
    notifyListeners();
  }
    void updateUser({String? id, String? number, double? latitude, double? longitude, String? address}) {
      _userServices.updateUserData({
        'id': id,
        'number': number,
        'latitude':latitude,
        'longitude':longitude,
        'address':address,
      });
  }
}