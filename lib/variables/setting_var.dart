import 'package:aria_ui/variables/page_var.dart';
import 'package:get/get.dart';

class SettingVar extends GetxController{
  String version="0.1.19";

  RxString rpc=''.obs;
  RxString secret=''.obs;

  var settings={}.obs;

  var defaultOrder=Order.oldTime.obs;
}