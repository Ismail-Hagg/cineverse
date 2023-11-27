import 'package:cineverse/models/actor_model.dart';
import 'package:get/get.dart';

class ActorController extends GetxController {
  ActorModel _actor = ActorModel();
  ActorModel get actor => _actor;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _actor = Get.arguments ?? ActorModel();
  }
}
