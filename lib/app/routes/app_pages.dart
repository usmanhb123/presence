import 'package:get/get.dart';

import '../modules/add_pegawai/bindings/add_pegawai_binding.dart';
import '../modules/add_pegawai/views/add_pegawai_view.dart';
import '../modules/face_verification/bindings/face_verification_binding.dart';
import '../modules/face_verification/views/face_verification_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/new_password/bindings/new_password_binding.dart';
import '../modules/new_password/views/new_password_view.dart';
import '../modules/presence_face/bindings/presence_face_binding.dart';
import '../modules/presence_face/views/presence_face_view.dart';
import '../modules/register_face/bindings/register_face_binding.dart';
import '../modules/register_face/views/register_face_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PEGAWAI,
      page: () => AddPegawaiView(),
      binding: AddPegawaiBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.NEW_PASSWORD,
      page: () => NewPasswordView(),
      binding: NewPasswordBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_FACE,
      page: () => const RegisterFaceView(),
      binding: RegisterFaceBinding(),
    ),
    GetPage(
      name: _Paths.PRESENCE_FACE,
      page: () => const PresenceFaceView(),
      binding: PresenceFaceBinding(),
    ),
    GetPage(
      name: _Paths.FACE_VERIFICATION,
      page: () => const FaceVerificationView(),
      binding: FaceVerificationBinding(),
    ),
  ];
}
