import 'package:flutter/material.dart';
import 'package:flutter_app/screens/login_screen.dart';
import 'package:flutter_app/screens/otp_screen.dart';
import 'package:flutter_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/auth_provider.dart';
import '../providers/location_provider.dart';

class SignUPScreen extends StatefulWidget {
  static const String id='Signupscreen';
  const SignUPScreen({super.key});

  @override
  State<SignUPScreen> createState() => _SignUPState();
}

class _SignUPState extends State<SignUPScreen> {
  bool _validPhoneNumber = false;
  final _phoneNumberController = TextEditingController();
  User user = FirebaseAuth.instance.currentUser!;
  bool _loggedIn=false;
  String _name = '';
  String _dob = '';
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
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
                const SizedBox(height: 20),
                const Text('Sign UP', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text(
                  'Enter Your Details',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                      prefixText: '+91',
                      labelText: '10 digit mobile number',
                      labelStyle:
                      TextStyle(color: Colors.deepPurpleAccent),
                      focusedBorder: UnderlineInputBorder(
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
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter Name',
                      labelStyle:
                      TextStyle(color: Colors.deepPurpleAccent),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.deepPurpleAccent),
                      )
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) => _name = value!,
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Enter DOB',
                      labelStyle:
                      TextStyle(color: Colors.deepPurpleAccent),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.deepPurpleAccent),
                      )
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your date of birth.';
                    }
                    return null;
                  },
                  onSaved: (value) => _dob = value!,
                ),
                const SizedBox(height: 10),
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
                    setState(() {
                      auth.screen='Login';
                    });
                    auth.loading=false;
                    Navigator.pushReplacementNamed(context, LoginScreen.id);
                  },
                ),
                const SizedBox(height: 20),
                AbsorbPointer(
                  absorbing: _validPhoneNumber ? false : true,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width-40,
                    child: TextButton(
                      style: _validPhoneNumber ? TextButton.styleFrom(
                        foregroundColor: _validPhoneNumber?Colors.white : Colors.black,
                        backgroundColor: _validPhoneNumber?Colors.deepPurpleAccent : Colors.grey,
                      ):TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: (){
                        if(_loggedIn==false){
                          auth.createUser(
                            id: user.uid,
                            number: user.phoneNumber!,
                            latitude: locationData.latitude,
                            longitude: locationData.longitude,
                            address: locationData.selectedAddress,);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> OTPScreen(phoneNumber: user.phoneNumber!)));
                        }else{
                          _loggedIn=true;
                          auth.updateUser(
                            id: user.uid,
                            number: user.phoneNumber,
                            latitude: locationData.latitude,
                            longitude: locationData.longitude,
                            address: locationData.selectedAddress,
                          );
                          Visibility(
                            visible: _loggedIn=='Already Have a Account' ? true:false,
                            child: Container(
                              child:
                              Column(
                                  children: [
                                    Text('Login', style: const TextStyle(color: Colors.red, fontSize: 12),),
                                    const SizedBox(height: 3,),
                                  ]
                              ),
                            ),
                          );
                        }
                      },
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
