import "package:flutter/material.dart";
import "package:flutter_app/providers/auth_provider.dart";
import "package:flutter_app/screens/otp_screen.dart";
import "package:flutter_app/screens/signup_screen.dart";
import "package:provider/provider.dart";

import "../providers/location_provider.dart";
import "map_screen.dart";

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  const LoginScreen({super.key});


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _validPhoneNumber = false;
  final _phoneNumberController = TextEditingController();
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
            children: <Widget>[
              const SizedBox(height: 30),
              IconButton(
                icon: const Stack(children: <Widget>[
                  Icon(Icons.arrow_back,color: Colors.black,),
                  Icon(Icons.arrow_back,color: Colors.black,),
                ],),
                onPressed: (){
                  auth.loading=false;
                  Navigator.pushReplacementNamed(context, MapScreen.id);
                }, ),
              const Text('Login', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text(
                'Enter your phone number to proceed',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: const InputDecoration(
                    prefixText: '+91',
                    labelText: '10 digit mobile number',
                    labelStyle:
                    TextStyle(color: Colors.deepPurple),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.deepPurple),
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
                    child: Column(
                      children: [
                        AbsorbPointer(
                          absorbing: _validPhoneNumber ? false : true,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width-40,
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
                                    ? Colors.deepPurple
                                    : Colors.grey,
                              ),
                              child: auth.loading?const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ):Text(
                                _validPhoneNumber
                                    ? 'CONTINUE'
                                    : 'ENTER PHONE NUMBER',
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          child: RichText(
                            text: const TextSpan(
                                text: 'Not a Customer ? ',
                                style: TextStyle(color: Colors.grey),
                                children: [
                                  TextSpan(
                                      text: 'Sign Up',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurpleAccent))
                                ]),
                          ),
                          onPressed: () {
                            setState(() {
                              auth.screen='Login-Failecd';
                            });
                            Navigator.pushReplacementNamed(context, SignUPScreen.id);
                            auth.loading=false;
                          },
                        ),
                      ],
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
