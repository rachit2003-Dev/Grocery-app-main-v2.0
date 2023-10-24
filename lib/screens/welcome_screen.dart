import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/providers/location_provider.dart';
import 'package:flutter_app/screens/home_screen.dart';
import 'package:flutter_app/screens/map_screen.dart';
import 'package:flutter_app/screens/onboard_screen.dart';
import 'package:provider/provider.dart';

import 'otp_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id= 'welcome-screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    bool _validPhoneNumber = false;
    var _phoneNumberController = TextEditingController();

    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, StateSetter myState) {
            // var _phoneNumberController = TextEditingController();
            return Container(
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
                          myState(() {
                            _validPhoneNumber = true;
                          });
                        } else {
                          myState(() {
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
                                myState(() {
                                  auth.loading = false;
                                });
                                String number = '+91${_phoneNumberController.text}';
                                auth.verifyPhone(context: context, number: number).then((value) {
                                  _phoneNumberController.notifyListeners();
                                });
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: _validPhoneNumber
                                    ? Colors.deepPurpleAccent
                                    : Colors.grey,
                              ),
                              child: auth.loading ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ):
                              Text(
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
            );
          },
        ),
      );
    }
    final locationData= Provider.of<LocationProvider>(context,listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: OnBoardScreen(),
                ),
                const Text(
                  'Ready to order your Favourite drink',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                  child:locationData.loading?CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ): const Text(
                    'SET DELIVERY LOCATION',
                  ),
                  onPressed: () async{
                    setState(() {
                      locationData.loading=true;
                    });
                    await locationData.getCurrentPosition();
                    if(locationData.permissionAllowed==true){
                      Navigator.pushReplacementNamed(context, MapScreen.id);
                      setState(() {
                        locationData.loading=false;
                      });
                    }
                    else{
                      print('Permission Not Allowed');
                      setState(() {
                        locationData.loading=false;
                      });
                    }
                  }
                ),
                TextButton(
                  child: RichText(
                    text: const TextSpan(
                        text: 'Already a Customer ? ',
                        style: TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurpleAccent))
                        ]),
                  ),
                  onPressed: () {
                    auth.loading=false;
                    showBottomSheet(context);
                  },
                ),
              ],
            ),
            Positioned(
              right: 0.0,
              top: 10.0,
              child: TextButton(
                onPressed: (){
                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                },
                child: const Text(
                  'SKIP',
                  style: TextStyle(color: Colors.deepPurpleAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
