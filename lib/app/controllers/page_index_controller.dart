import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:nominatim_geocoding/nominatim_geocoding.dart';

import '../routes/app_pages.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;
  FirebaseAuth  auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void changePage(int i) async {
    switch (i) {
      case 1:
        print("absensi");
        Map<String, dynamic> dataResponse = await determinePosition();
        if (dataResponse["error"] != true) {
          Position position = dataResponse["position"];
          // print(dataResponse);
          await updatePostition(position);
          await generate(position);
          // generate();
          Get.snackbar("Berhasil", dataResponse["message"]);
        }else{
          Get.snackbar("Terjadi Kesalahan", dataResponse["message"]);
        }
        break;
      case 2:
        pageIndex.value = 1;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = 1;
        Get.offAllNamed(Routes.HOME);
    }
  }


Future<void> generate(Position position) async{
  // print("berhail");
  // const String googelApiKey = 'AIzaSyCO9d_vJ7onXMc81A_ivYXYRITEsnZvKDA';
  // final bool isDebugMode = true;  
  // final api = GoogleGeocodingApi(googelApiKey, isLogged: isDebugMode);  
  // final reversedSearchResults = await api.reverse(
  //   '42.360083,-71.05888',
  //   language: 'en',
  // );

  await Future.delayed(const Duration(seconds: 2));
  
  await NominatimGeocoding.init();
  Geocoding result = await NominatimGeocoding.to.reverseGeoCoding(
    const Coordinate(
        latitude: 52.27429313260939, longitude: 10.523078303155874),
  );
  print(result);

}



  Future<void> updatePostition(Position position) async{
     String uid = await auth.currentUser!.uid;
     await firestore.collection("pegawai").doc(uid).update({
      "position": {
        "lat" : position.latitude,
        "long" : position.longitude
      }
     });
     print("berhsil");
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');
      return {
        "message": "Tidak dapat mendapatkan GPS pada device ini!",
        "error": true
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        return {"message": "Izin untuk Location ditolak!", "error": true};
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
      return {
        "message": "Izin untuk Location anda belum di perbolehkan!",
        "error": true
      };
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return {
      "position": position,
      "message": "Berhasil mendapatkan posisi!",
      "error": false
    };
  }
}
