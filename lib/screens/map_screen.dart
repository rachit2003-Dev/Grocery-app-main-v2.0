import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:flutter_app/providers/location_provider.dart';
import 'package:flutter_app/screens/login_screen.dart';
import 'package:flutter_app/screens/welcome_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
class MapScreen extends StatefulWidget {
  static const String id='map-screen';

  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng currentLocation;
  late GoogleMapController _mapController;
  bool _locating=false;
  bool _loggedIn=false;
  late User user;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }
  void getCurrentUser()async {
    setState(() {
      user = FirebaseAuth.instance.currentUser!;
    });
    setState(() {
      _loggedIn=true;
      user = FirebaseAuth.instance.currentUser!;
    });
    }


  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData=Provider.of<LocationProvider>(context);

    setState(() {
      currentLocation = LatLng(locationData.latitude, locationData.longitude);
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: currentLocation,zoom: 14.4746,),
              zoomControlsEnabled: false,
              minMaxZoomPreference: const MinMaxZoomPreference(1.5,20.8),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              mapToolbarEnabled: true,
              onCameraMove:  (CameraPosition position){
                setState(() {
                  _locating=true;
                });
                locationData.onCameraMove(position);
              },
              onMapCreated: (GoogleMapController controller){
                setState(() {
                  _mapController=controller;
                });
              },
              onCameraIdle: (){
                _locating=false;
                locationData.getMoveCamera();
              },
            ),
            Positioned(
              top: 10.0,
              left: 10.0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),color: Theme.of(context).primaryColor,
                onPressed: () => Navigator.pushReplacementNamed(context, WelcomeScreen.id),
              ),
            ),
            Center(child: Container(
              height: 60,
              margin: const EdgeInsets.only(bottom: 40),
              child: Image.asset('asset/images/marker.png'),
              ),
            ),
            const Center(
              child: SpinKitPulse(
                color: Colors.deepPurple,
                size: 75.0,
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                height: 230,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      _locating ? LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                        backgroundColor: Colors.transparent,
                      ) : Container(),
                      Padding(padding: const EdgeInsets.all(10),

                        child: Column(
                          children: [
                            TextButton(
                              onPressed: (){locationData.getCurrentPosition();},
                              style: TextButton.styleFrom(backgroundColor: Theme.of(context).primaryColor,),
                              child: const Icon(Icons.my_location,
                                color: Colors.white,),
                            ),
                            const SizedBox(height: 10),
                            const Text('SELECT DELIVERY LOCATION', style: TextStyle(color: Colors.black54,fontSize: 10),)

                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 20),
                        child: TextButton.icon(
                          onPressed: (){},
                          icon: Icon(Icons.location_searching_sharp, color: Theme.of(context).primaryColor,),
                          label: Text(
                            _locating ? 'Locating' : locationData.selectedAddress,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width-40,
                          child: AbsorbPointer(
                            absorbing: _locating ? true:false,
                            child: TextButton(
                              style: _locating ? TextButton.styleFrom(
                               foregroundColor: Colors.black,
                               backgroundColor: Colors.grey,
                                  ):TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              onPressed: (){
                                if(_loggedIn==false){
                                    Navigator.pushNamed(context, LoginScreen.id);
                                }else{
                                  auth.updateUser(
                                    id: user.uid,
                                    number: user.phoneNumber,
                                    latitude: locationData.latitude,
                                    longitude: locationData.longitude,
                                    address: locationData.selectedAddress,
                                  );
                                  Navigator.pushReplacementNamed(context, LoginScreen.id);
                                }
                              },
                                child: const Text('CONFIRM LOCATION'), ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

