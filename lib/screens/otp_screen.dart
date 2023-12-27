import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/location_provider.dart';

class OTPScreen extends StatefulWidget {
  static const String id = 'otp_screen';
  const OTPScreen({super.key, required this.phoneNumber});
  final String phoneNumber;


  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OTPScreen> {
  late TextEditingController _otpController1, _otpController2, _otpController3, _otpController4, _otpController5, _otpController6;
  late FocusNode _focusNode1, _focusNode2, _focusNode3, _focusNode4, _focusNode5, _focusNode6;
  late Timer countdownTimer;
  late int resendTime=20;

  @override
  void initState() {
    startTimer();
    super.initState();
    _otpController1 = TextEditingController();
    _otpController2 = TextEditingController();
    _otpController3 = TextEditingController();
    _otpController4 = TextEditingController();
    _otpController5 = TextEditingController();
    _otpController6 = TextEditingController();

    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
    _focusNode3 = FocusNode();
    _focusNode4 = FocusNode();
    _focusNode5 = FocusNode();
    _focusNode6 = FocusNode();
  }
  void startTimer(){
    countdownTimer=Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        resendTime = resendTime-1;
      });
      if(resendTime<1){
        countdownTimer.cancel();
      }
    });
  }
  void stopTimer(){
    if(countdownTimer.isActive){
      countdownTimer.cancel();
    }
  }

  void nextField({required String value, required FocusNode focusNode}) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    LocationProvider locationData = Provider.of<LocationProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: const Stack(children: <Widget>[
                  Icon(Icons.arrow_back,color: Colors.black,),
                  Icon(Icons.arrow_back,color: Colors.black,),
                ],),
                onPressed: (){
                  auth.loading=false;
                  Navigator.pushReplacementNamed(context, WelcomeScreen.id);
                }, ),
              const Text('OTP Verification', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('OTP sent to ${widget.phoneNumber}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Visibility(
                visible: auth.error=='Invalid OTP' ? true:false,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Color(0xff882f8c),
                          Color(0xfffda3ff),
                        ],
                        stops: [
                          0.0,
                          0.5
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter),
                  ),
                  child:
                      Column(
                      children: [
                        Text('${auth.error}- Try Again', style: const TextStyle(color: Colors.red, fontSize: 12),),
                        const SizedBox(height: 3,),
                      ]
                    ),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Enter the OTP', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(child: buildCodeNumberBox(_otpController1, nextField: (value) => nextField(value: value, focusNode:_focusNode2), focusNode:_focusNode1)),
                  Flexible(child: buildCodeNumberBox(_otpController2, nextField: (value) => nextField(value: value, focusNode:_focusNode3), focusNode:_focusNode2)),
                  Flexible(child: buildCodeNumberBox(_otpController3, nextField: (value) => nextField(value: value, focusNode:_focusNode4), focusNode:_focusNode3)),
                  Flexible(child: buildCodeNumberBox(_otpController4, nextField: (value) => nextField(value: value, focusNode:_focusNode5), focusNode:_focusNode4)),
                  Flexible(child: buildCodeNumberBox(_otpController5, nextField: (value) => nextField(value: value, focusNode:_focusNode6), focusNode:_focusNode5)),
                  Flexible(child: buildCodeNumberBox(_otpController6,focusNode:_focusNode6)),
                ],
              ),
              const SizedBox(height: 10),
              TextButton(
                child: RichText(
                  text: TextSpan(
                      text: 'Did not recieve OTP? ',
                      style: const TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                            text: resendTime>0?'00:$resendTime': 'Resend OTP',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurpleAccent))
                      ]),
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              MaterialButton(
                onPressed: () async {
                  String otp = '${_otpController1.text}${_otpController2.text}${_otpController3.text}${_otpController4.text}${_otpController5.text}${_otpController6.text}';
                  try {
                    PhoneAuthCredential phoneAuthCredential =
                    PhoneAuthProvider.credential(
                        verificationId: auth.verificationId, smsCode: otp);

                    final User? user =
                        (await auth.signInWithCredential(phoneAuthCredential))?.user;

                  } catch (e) {
                    auth.error = 'Invalid OTP';
                    auth.notifyListeners();
                    print(e.toString());
                  }
                },
                height: 50,
                minWidth: double.infinity,
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: const Text('Verify', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCodeNumberBox(TextEditingController controller,{void Function(String)? nextField, required FocusNode focusNode}) {
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal:
      MediaQuery.of(context).size.width / 30),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 9,
        child: TextFormField(
          maxLength: 1,
          controller: controller,
          focusNode: focusNode,
          autofocus: true,
          obscureText: true,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            counterText: '',
            contentPadding:
            EdgeInsets.symmetric(vertical:
            MediaQuery.of(context).size.width / 15),
            enabledBorder:
            OutlineInputBorder(borderRadius:
            BorderRadius.circular(15), borderSide:
            BorderSide(color: Colors.grey.shade300)),
            focusedBorder:
            OutlineInputBorder(borderRadius:
            BorderRadius.circular(15), borderSide:
            BorderSide(color: Colors.grey.shade300)),
            border:
            OutlineInputBorder(borderRadius:
            BorderRadius.circular(15), borderSide:
            BorderSide(color: Colors.grey.shade300)),
          ),
          onChanged:(value) {
            if (nextField != null) {
              nextField(value);
            }
          },
        ),
      ),
    );
  }
}