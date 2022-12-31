import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class GeolocatorController extends GetxController{

  bool isLoadingFinish = false;
  bool isRequiredPermission = false;
  late Position currentLocation;

  Future<Position?> getLocation() async {
    print("getLocationStart");
    var perm = await Geolocator.checkPermission();
    if(perm == LocationPermission.denied){
      return null;
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    ).catchError((e){
      print("Error $e");
    });
  }

  void permissionOK(){

    getLocation().then((pos){
      isLoadingFinish = true;
      currentLocation = pos!;
      if(pos == null) {
        isRequiredPermission = true;
      }else{
        isRequiredPermission = false;
      }
    });

  }


}