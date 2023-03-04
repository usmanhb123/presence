import 'package:get/get.dart';

import '../controllers/detail_pegawai_controller.dart';

class DetailPegawaiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailPegawaiController>(
      () => DetailPegawaiController(),
    );
  }
}
