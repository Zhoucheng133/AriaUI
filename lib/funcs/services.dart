
import 'package:aria_ui/request/requests.dart';
import 'package:aria_ui/variables/task_var.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';

class Services{

  final TaskVar t=Get.put(TaskVar());

  Future<void> getActives(BuildContext context) async {
    List lists=await Requests().getActive(context);
    if(lists.isNotEmpty){
      t.active.value=lists;
    }
  }
}