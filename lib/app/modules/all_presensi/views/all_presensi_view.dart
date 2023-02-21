import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../routes/app_pages.dart';
import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  const AllPresensiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Presensi'),
        centerTitle: true,
      ),
      body: GetBuilder<AllPresensiController>(
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
                            Map<String, dynamic> data =
                                snapshot.data!.docs[index].data();
                            return Container(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Material(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[200],
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed(Routes.DETAIL_PRESENSI,
                                        arguments: data);
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
                                                "${DateFormat.yMMMEd().format(DateTime.parse(data["date"]))}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ]),
                                        Text(data["masuk"]?["date"] == null
                                            ? "-"
                                            : "${DateFormat.jms().format(DateTime.parse(data["masuk"]!["date"]))}"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Keluar",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(data["keluar"]?["date"] == null
                                            ? "-"
                                            : "${DateFormat.jms().format(DateTime.parse(data["keluar"]!["date"]))}"),
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
