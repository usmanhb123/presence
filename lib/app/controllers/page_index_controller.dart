import 'package:get/get.dart';

import '../routes/app_pages.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  void changePage(int i) async {
    switch (i) {
      case 1:
        print("absensi");
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
}
