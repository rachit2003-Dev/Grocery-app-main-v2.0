
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier{
  late double latitude;
  late double longitude;
  bool permissionAllowed=false;
  late String selectedAddress="";
  bool loading=false;

  Future<void>getCurrentPosition()async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if(position!=false){
      this.latitude=position.latitude;
      this.longitude=position.longitude;
      List<Placemark> placemarks = await placemarkFromCoordinates(this.latitude, this.longitude);
      this.permissionAllowed=true;
      notifyListeners();
    }
    else{
      print('Permission Not ALllowed');
    }
  }

  void onCameraMove(CameraPosition cameraPosition)async{
    this.latitude=cameraPosition.target.latitude;
    this.longitude=cameraPosition.target.longitude;
    notifyListeners();
  }


  Future<void>getMoveCamera()async{
    List<Placemark> placemarks = await placemarkFromCoordinates(this.latitude, this.longitude);
    selectedAddress = placemarks.reversed.last.postalCode.toString()+" "+placemarks.reversed.last.subLocality.toString()+""+placemarks.reversed.last.name.toString();
  }
}