import "package:flutter/material.dart";
import "package:flutter_app/providers/auth_provider.dart";
import "package:flutter_app/screens/home_screen.dart";
import "package:flutter_app/screens/otp_screen.dart";
import "package:get/get.dart";
import "package:provider/provider.dart";

import "../providers/location_provider.dart";

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _validPhoneNumber = false;
  var _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: auth.error=='Invalid OTP' ? true:false,
                child: Container(
                  child: Column(
                    children: [
                      Text('${auth.error}- Try Again', style: TextStyle(color: Colors.red, fontSize: 12),),
                      const SizedBox(height: 3,),
                    ],
                  ),
                ),
              ),
              const Text(
                'LOGIN',
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Enter your phone number to proceed',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                    prefixText: '+91',
                    labelText: '10 digit mobile number',
                    labelStyle:
                    const TextStyle(color: Colors.deepPurpleAccent),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.deepPurpleAccent),
                    )),
                autofocus: true,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                controller: _phoneNumberController,
                onChanged: (value) {
                  if (value.length == 10) {
                    setState(() {
                      _validPhoneNumber = true;
                    });
                  } else {
                    setState(() {
                      _validPhoneNumber = false;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: AbsorbPointer(
                      absorbing: _validPhoneNumber ? false : true,
                      child: TextButton(
                        onPressed: () {
                          setState((){
                            auth.loading=true;
                          });
                          String number =
                              '+91${_phoneNumberController.text}';
                          auth.verifyPhone(
                              context: context,
                              number: number,
                            latitude: locationData.latitude,
                            longitude: locationData.longitude,
                            address: locationData.selectedAddress,
                          ).then((value){
                            _phoneNumberController.clear();
                            setState(() {
                              auth.loading=false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OTPScreen(phoneNumber: number),
                              ),
                            );
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: _validPhoneNumber
                              ? Colors.deepPurpleAccent
                              : Colors.grey,
                        ),
                        child: auth.loading?CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ):Text(
                          _validPhoneNumber
                              ? 'CONTINUE'
                              : 'ENTER PHONE NUMBER',
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
