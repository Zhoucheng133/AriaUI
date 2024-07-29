
import 'dart:async';

import 'package:aria_ui/request/requests.dart';
import 'package:aria_ui/variables/page_var.dart';
import 'package:aria_ui/variables/task_var.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Services{

  final TaskVar t=Get.put(TaskVar());
  final PageVar p=Get.put(PageVar());
  late Timer interval;

  // 移除任务
  Future<void> remove(String gid) async {
    await Requests().removeTask(gid);
  }

  // 请求活跃的任务
  Future<void> tellActive() async {
    List? lists=await Requests().tellActive();
    if(lists!=null){
      t.active.value=lists;
    } 
  }

  // 请求等待中的任务
  Future<void> tellWaiting() async {
    List? lists=await Requests().tellWaiting();
    if(lists!=null){
      t.waiting.value=lists;
    }
  }


  // 请求停止的任务
  Future<void> tellStopped() async {
    List? lists=await Requests().tellStopped();
    if(lists!=null){
      t.stopped.value=lists;
    }
  }

  // 主服务
  void serviceMain(){
    if(p.nowPage.value=='活跃中'){
      tellActive();
    }else if(p.nowPage.value=='等待中'){
      tellWaiting();
    }else if(p.nowPage.value=='已完成'){
      tellStopped();
    }
  }

  // 开始服务
  Future<void> startService(BuildContext context) async {
    String? version=await Requests().getVersion();
    if(version==null){
      if(context.mounted){
        await showDialog(
          context: context, 
          builder: (context)=>ContentDialog(
            title: Text('无法连接到Aria服务器', style: GoogleFonts.notoSansSc(),),
            content: Text('检查RPC地址和密码是否正确!', style: GoogleFonts.notoSansSc(),),
            actions: [
              FilledButton(
                child: Text('好的', style: GoogleFonts.notoSansSc(),), 
                onPressed: (){
                  Navigator.pop(context);
                }
              )
            ],
          )
        );
      }
      return;
    }
    // getActives();
    interval= Timer.periodic(const Duration(seconds: 1), (Timer time){
      serviceMain();
    });
  }

  // 添加任务
  Future<void> addTask(String url) async {
    await Requests().addTask(url);
  }

  // 销毁服务
  void destoryServive(){
    interval.cancel();
  }
}