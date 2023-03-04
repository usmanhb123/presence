import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/routes/app_pages.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controllers/detail_pegawai_controller.dart';

class DetailPegawaiView extends GetView<DetailPegawaiController> {
  final Map<String, dynamic> data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    print(data);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pegawai'),
        centerTitle: true,
      ),
      body: GetBuilder<DetailPegawaiController>(
        builder: (c) => SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                        child: InkWell(
                          onTap: () {},
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    ),
                    Text(
                      'Semua Presensi',
                      style: TextStyle(fontSize: 20),
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: controller.getPresence(data['uid']),
                    builder: (context, snapshot) {
                      if (snapshot.data?.docs.length == 0) {
                        return Container(
                          child: Column(children: [
                            Image.asset(
                              'assets/lottiefiles/tidak_ada.gif',
                              height: Get.width * 0.1,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: Text(
                                "Tidak ada history absen",
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
                            Map<String, dynamic> detail =
                                snapshot.data!.docs[index].data();
                            return Container(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Material(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[200],
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed(Routes.DETAIL_PRESENSI,
                                        arguments: detail);
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Masuk",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "${DateFormat.yMMMEd().format(DateTime.parse(detail["date"]))}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ]),
                                        Text(detail["masuk"]?["date"] == null
                                            ? "-"
                                            : "${DateFormat.jms().format(DateTime.parse(detail["masuk"]!["date"]))}"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Keluar",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(detail["keluar"]?["date"] == null
                                            ? "-"
                                            : "${DateFormat.jms().format(DateTime.parse(detail["keluar"]!["date"]))}"),
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
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // showDatePicker(context: context, initialDate: DateTime(2023), firstDate: DateTime(2000), lastDate: DateTime(2200),);

            Get.dialog(Dialog(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.all(20),
                height: 400,
                child: SfDateRangePicker(
                  monthViewSettings:
                      DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                  selectionMode: DateRangePickerSelectionMode.range,
                  showActionButtons: true,
                  onCancel: () => Get.back(),
                  onSubmit: (obj) {
                    if (obj != null) {
                      if ((obj as PickerDateRange).endDate != null) {
                        controller.picDate(obj.startDate!, obj.endDate!);
                      }
                    }
                  },
                ),
              ),
            ));
          },
          child: Icon(Icons.search)),
    );
  }
}
