
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier{
  late double latitude=0.0;
  late double longitude=0.0;
  bool permissionAllowed=false;
  late String selectedAddress="";
  bool loading=false;

  Future<void>getCurrentPosition()async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(position!=false){
      latitude=position.latitude;
      longitude=position.longitude;
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      permissionAllowed=true;
      notifyListeners();
    }
    else{
      print('Permission Not ALllowed');
    }
  }

  void onCameraMove(CameraPosition cameraPosition)async{
    latitude=cameraPosition.target.latitude;
    longitude=cameraPosition.target.longitude;
    notifyListeners();
  }


  Future<void>getMoveCamera()async{
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    selectedAddress = "${placemarks.reversed.last.subLocality} ${placemarks.reversed.last.subAdministrativeArea}${placemarks.reversed.last.name}";
  }
}