import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/controllers/page_index_controller.dart';
import 'package:presence/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: controller.streamUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  Map<String, dynamic> user = snapshot.data!.data()!;
                  return ListView(
                    padding: EdgeInsets.all(15),
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Container(
                              width: 75,
                              height: 75,
                              color: Colors.grey,
                              child: Image.network(
                                  user['profile'] == null
                                      ? "https://ui-avatars.com/api/?name=${user['nama']}"
                                      : user['profile'],
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Container(
                                  width: Get.width * 0.4,
                                  child: Text(
                                    user['address'] == null
                                        ? "Belum ada lokasi"
                                        : "${user['address']}",
                                    textAlign: TextAlign.left,
                                  ))
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        // height: 250,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${user['job']}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "${user['nip']}",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text("${user['nama']}"),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(20),
                        // height: 250,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)),
                        child: StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>>(
                            stream: controller.streamToDayPresence(),
                            builder: (context, snaptoday) {
                              if (snaptoday.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              Map<String, dynamic>? datatoday =
                                  snaptoday.data?.data();
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text("Masuk"),
                                      Text(datatoday?["masuk"] == null
                                          ? "-"
                                          : "${DateFormat.jms().format(DateTime.parse(datatoday?["masuk"]!["date"]))}")
                                    ],
                                  ),
                                  Container(
                                    width: 2,
                                    height: 40,
                                    color: Colors.grey,
                                  ),
                                  Column(
                                    children: [Text("Keluar"),  Text(datatoday?["keluar"] == null
                                          ? "-"
                                          : "${DateFormat.jms().format(DateTime.parse(datatoday?["keluar"]!["date"]))}")],
                                  )
                                ],
                              );
                            }),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Last 5 day",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          TextButton(
                              onPressed: () =>
                                  {Get.toNamed(Routes.ALL_PRESENSI)},
                              child: Text("See more")),
                        ],
                      ),
                      SizedBox(height: 10),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: controller.streamLastPresence(),
                          builder: (context, snapPresensi) {
                            if (snapPresensi.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapPresensi.data?.docs.length == 0) {
                              return Container(
                                child: Column(children: [
                                  Image.asset(
                                    'assets/lottiefiles/tidak_ada.gif',
                                   
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Center(
                                    child: Text(
                                      "Belum ada history absen",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                ]),
                              );
                            }

                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapPresensi.data!.docs.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (contextx, index) {
                                  Map<String, dynamic> data =
                                      snapPresensi.data!.docs[index].data();
                                  return Container(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.grey[200],
                                      child: InkWell(
                                        onTap: () {
                                          Get.toNamed(Routes.DETAIL_PRESENSI, arguments: data);
                                        },
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Masuk",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "${DateFormat.yMMMEd().format(DateTime.parse(data["date"]))}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                              Text(data["masuk"]?["date"] ==
                                                      null
                                                  ? "-"
                                                  : "${DateFormat.jms().format(DateTime.parse(data["masuk"]!["date"]))}"),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "Keluar",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(data["keluar"]?["date"] ==
                                                      null
                                                  ? "-"
                                                  : "${DateFormat.jms().format(DateTime.parse(data["keluar"]!["date"]))}"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          })
                    ],
                  );
                } else {
                  // Get.offAllNamed(Routes.HOME);
                  return Center(child: Text("Tidak dapat memuat data!"));
                }
              }),
        ),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.fixedCircle,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.fingerprint, title: 'Add'),
            TabItem(icon: Icons.people, title: 'Profile'),
          ],
          initialActiveIndex: 0,
          onTap: (int i) => pageC.changePage(i),
        ));
  }
}
