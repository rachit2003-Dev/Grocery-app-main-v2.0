import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/location_provider.dart';
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
  late String screen;

  Future<UserCredential?> signInWithCredential(PhoneAuthCredential credential) async {
    return await _auth.signInWithCredential(credential);
  }
  Future<void> verifyPhone({BuildContext? context, String? number}) async {
    loading=true;
    notifyListeners();
    verificationCompleted(PhoneAuthCredential credential) async {
      loading=false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    }

    verificationFailed(FirebaseAuthException e) {
      loading=false;
      print(e.code);
      error=e.toString();
      notifyListeners();
    }

    smsOtpSend(String verId, [int? resendToken]) async {
      verificationId = verId;
      // Navigate to OTPScreen
      Navigator.push(
        context!,
        MaterialPageRoute(
          builder: (context) => OTPScreen(phoneNumber: number!),
        ),
      );
    }

    try {
      _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsOtpSend,
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
      );
    } catch (e) {
      error=e.toString();
      loading=false;
      notifyListeners();
      print(e);
    }
  }


  void createUser({required String id, required String number, required  double latitude, required double longitude, required String address}) {
    _userServices.createUserData({
      'id': id,
      'number': number,
      'latitude':locationData.latitude,
      'longitude':locationData.longitude,
      'address': locationData.selectedAddress,
    });
    loading = false;
    notifyListeners();
    print('Hello');
  }
    void updateUser({String? id, String? number, double? latitude, double? longitude, String? address}) {
      _userServices.updateUserData({
        'id': id,
        'number': number,
        'latitude':locationData.latitude,
        'longitude':locationData.longitude,
        'address':locationData.selectedAddress,
      });
      loading = false;
      notifyListeners();
  }
}