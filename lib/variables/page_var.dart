import 'package:get/get.dart';

enum Order{
  newTime,
  oldTime,
  titleA,
  titleZ,
}

enum Pages{
  about,
  fold,
  active,
  finished,
  settings,
}

class PageVar extends GetxController{
  RxBool fold=true.obs;
  var nowPage=Pages.active.obs;

  var activeOrder=Order.newTime.obs;
  var finishedOrder=Order.newTime.obs;
}