import 'package:get/get.dart';

class PageVar extends GetxController{
  RxBool fold=true.obs;
  RxString nowPage='活跃中'.obs;

  // newTime, oldTime, titleA, titleZ
  RxString activeOrder='newTime'.obs;
  RxString finishedOrder='newTime'.obs;
}