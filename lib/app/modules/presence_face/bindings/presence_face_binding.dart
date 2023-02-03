import 'package:get/get.dart';

import '../controllers/presence_face_controller.dart';

class PresenceFaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PresenceFaceController>(
      () => PresenceFaceController(),
    );
  }
}
