import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/all_pegawai_controller.dart';

class AllPegawaiView extends GetView<AllPegawaiController> {
  const AllPegawaiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Pegawai'),
        centerTitle: true,
      ),
      body: GetBuilder<AllPegawaiController>(
        builder: (c) => SafeArea(
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: controller.getPresence(),
                    builder: (context, snapshot) {
                      if (snapshot.data?.docs.length == 0) {
                        return Container(
                          child: Column(children: [
                            Image.asset(
                              'assets/lottiefiles/tidak_ada.gif',
                              height: Get.width * 0.4,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Text(
                                "Tidak ada pegwawai",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          ]),
                        );
                      }

                      return ListView.builder(
                          padding: EdgeInsets.only(
                              top: 20, left: 20, bottom: 20, right: 20),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          // physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (contextx, index) {
                            Map<String, dynamic> data =
                                snapshot.data!.docs[index].data();
                            return Container(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Material(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[200],
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed(Routes.DETAIL_PEGAWAI,
                                        arguments: data);
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            width: 75,
                                            height: 75,
                                            color: Colors.grey,
                                            child: Image.network(
                                                data['profile'] == null
                                                    ? "https://ui-avatars.com/api/?name=${data['nama']}"
                                                    : data['profile'],
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${data['nama']}",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "${data['nip']}",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 10),
                                            Text("${data['job']}"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
