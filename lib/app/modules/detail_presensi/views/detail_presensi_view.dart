import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  final Map<String, dynamic> data = Get.arguments;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Presensi'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "${DateFormat.yMMMEd().format(DateTime.parse(data["date"]))}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Masuk",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text( data["masuk"] != null?
                    "Jam          : ${DateFormat.jms().format(DateTime.parse(data["masuk"]!["date"]))}"
                    : "Jam          : -"),
                  Text(data["masuk"] != null?
                    "Distance  : ${data["masuk"]!["distance"].toString().replaceAll(".", ",").substring(0, 5)} Meter" :
                    "Distance  : -"),
                  Text(data["masuk"] != null?
                    "Address   : ${data["masuk"]!["addres"]}" :
                    "Address   : -"),
                     Text(
                     data["masuk"] != null?
                    "Posisi       : ${data["masuk"]!["lat"]}, ${data["masuk"]!["long"]}" :
                    "Posisi       : -"
                    ),
                  SizedBox(height: 20),
                  Text(
                    "Keluar",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    data["keluar"] != null?
                    "Jam          : ${DateFormat.jms().format(DateTime.parse(data["keluar"]!["date"]))}"
                    : "Jam          : -"
                    ),
                  Text(data["keluar"] != null?
                    "Distance  : ${data["keluar"]!["distance"].toString().replaceAll(".", ",").substring(0, 5)} Meter" :
                    "Distance  : -"),
                  Text(
                     data["keluar"] != null?
                    "Address   : ${data["keluar"]!["addres"]}" :
                    "Address   : -"
                    ),
                  Text(
                     data["keluar"] != null?
                    "Posisi       : ${data["keluar"]!["lat"]}, ${data["keluar"]!["long"]}" :
                    "Posisi       : -"
                    ),
                ],
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200]),
            )
          ],
        ));
  }
}
