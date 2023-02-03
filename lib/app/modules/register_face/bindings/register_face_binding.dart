import 'package:get/get.dart';

import '../controllers/register_face_controller.dart';

class RegisterFaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterFaceController>(
      () => RegisterFaceController(),
    );
  }
}
