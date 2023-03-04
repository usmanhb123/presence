import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../routes/app_pages.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void changePage(int i) async {
    switch (i) {
      case 1:
        print("absensi");
        Map<String, dynamic> dataResponse = await determinePosition();
        CollectionReference is_location =
            await FirebaseFirestore.instance.collection('is_location');
            DocumentSnapshot<Object?> final_location = await is_location.doc("1").get();
          
        if (dataResponse["error"] != true) {
          Position position = dataResponse["position"];
          final lok =
              await generatePosition(position.latitude, position.longitude);
          await updatePostition(position, lok['display_name']);

          double distance = Geolocator.distanceBetween(
              double.parse(final_location['lat']), double.parse(final_location['long']),
              // -6.2062592, 106.8302336
               position.latitude, position.longitude);
          await presensi(position, lok['display_name'], distance);
          // Get.snackbar("Berhasil", dataResponse["message"]);
        } else {
          // Get.snackbar("Terjadi Kesalahan", dataResponse["message"]);
          await Get.defaultDialog(
              barrierDismissible: false,
              title: "Terjadi Kesalahan",
              middleText: dataResponse["message"],
              actions: [
                ElevatedButton(
                    onPressed: () async {
                      Get.back();
                    },
                    child: Text("OK")),
              ]);
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

  Future<dynamic> generatePosition(lat, long) async {
    final String url =
        "https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${lat}&lon=${long}";
    var result = await http.get(Uri.parse(url));
    return json.decode(result.body);
  }

  Future<void> presensi(Position position, address, double distance) async {
    String uid = await auth.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> colPresensi =
        await firestore.collection("pegawai").doc(uid).collection("presence");

    QuerySnapshot<Map<String, dynamic>> snapPresensi = await colPresensi.get();
    String status = "Didalam area";
    if (distance <= 200) {
      status = "Didalam area";

      DateTime now = DateTime.now();
      String docID = DateFormat.yMd().format(now).replaceAll("/", "-");
      if (snapPresensi.docs.length == 0) {
        await Get.defaultDialog(
            title: "Validasi Presensi",
            middleText: "Kamu akan absen masuk sekarang?",
            actions: [
              OutlinedButton(
                  onPressed: () => Get.back(), child: Text("Cancel")),
              ElevatedButton(
                  onPressed: () async {
                    await colPresensi.doc(docID).set({
                      "date": now.toIso8601String(),
                      "masuk": {
                        "date": now.toIso8601String(),
                        "lat": position.latitude,
                        "long": position.longitude,
                        "addres": address,
                        "status": status,
                        "distance": distance
                      }
                    });
                    Get.back();
                    Get.snackbar("Berhasil", "Kamu berhasil absen masuk");
                  },
                  child: Text("Ya")),
            ]);
      } else {
        DocumentSnapshot<Map<String, dynamic>> toDayDoc =
            await colPresensi.doc(docID).get();

        if (toDayDoc.exists == true) {
          Map<String, dynamic>? dataPresencetoday = toDayDoc.data();
          if (dataPresencetoday?["keluar"] != null) {
            Get.snackbar("Success",
                "Kamu telah absen masuk dan keluah hari ini terimakasih");
          } else {
            await Get.defaultDialog(
                title: "Validasi Presensi",
                middleText: "Kamu akan absen keluar sekarang?",
                actions: [
                  OutlinedButton(
                      onPressed: () => Get.back(), child: Text("Cancel")),
                  ElevatedButton(
                      onPressed: () async {
                        await colPresensi.doc(docID).update({
                          "keluar": {
                            "date": now.toIso8601String(),
                            "lat": position.latitude,
                            "long": position.longitude,
                            "addres": address,
                            "status": status,
                            "distance": distance
                          }
                        });
                        Get.back();
                        Get.snackbar("Berhasil", "Kamu berhasil absen keluar");
                      },
                      child: Text("Ya")),
                ]);
          }
        } else {
          await Get.defaultDialog(
              title: "Validasi Presensi",
              middleText: "Kamu akan absen masuk sekarang?",
              actions: [
                OutlinedButton(
                    onPressed: () => Get.back(), child: Text("Cancel")),
                ElevatedButton(
                    onPressed: () async {
                      await colPresensi.doc(docID).set({
                        "date": now.toIso8601String(),
                        "masuk": {
                          "date": now.toIso8601String(),
                          "lat": position.latitude,
                          "long": position.longitude,
                          "addres": address,
                          "status": status,
                          "distance": distance
                        }
                      });
                      Get.back();
                      Get.snackbar("Berhasil", "Kamu berhasil absen masuk");
                    },
                    child: Text("Ya")),
              ]);
        }
      }
    } else {
      Get.snackbar("Terjadi kesalahan", "Kamu terlalu jauh dengan jangkauan pastikan kamu berada dijangkauan perusahaan yaitu 200 meter!");
    }
  }

  Future<void> updatePostition(Position position, address) async {
    String uid = await auth.currentUser!.uid;
    await firestore.collection("pegawai").doc(uid).update({
      "position": {"lat": position.latitude, "long": position.longitude},
      "address": address
    });
    // print("berhsil");
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
