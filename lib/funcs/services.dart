import 'dart:async';

import 'package:aria_ui/request/requests.dart';
import 'package:aria_ui/variables/page_var.dart';
import 'package:aria_ui/variables/setting_var.dart';
import 'package:aria_ui/variables/task_var.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Services{

  final TaskVar t=Get.put(TaskVar());
  final PageVar p=Get.put(PageVar());
  final SettingVar s=Get.put(SettingVar());
  late Timer interval;

  // 移除任务
  Future<void> remove(String gid) async {
    await Requests().removeTask(gid);
  }

  // 请求活跃的任务
  Future<void> tellActive() async {
    List? alists=await Requests().tellActive();
    List? wlists=await Requests().tellWaiting();
    if(alists!=null && wlists!=null){
      t.active.value=(alists..addAll(wlists)).reversed.toList();
    } 
  }

  // 请求停止的任务
  Future<void> tellStopped() async {
    List? lists=await Requests().tellStopped();
    if(lists!=null){
      t.stopped.value=lists.reversed.toList();
    }
  }

  // 主服务
  void serviceMain(){
    if(p.nowPage.value=='活跃中'){
      tellActive();
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
    serviceMain();
  }

  // 销毁服务
  void destoryServive(){
    interval.cancel();
  }

  // 暂停任务
  Future<void> pauseTask(String gid) async {
    await Requests().pauseTask(gid);
    serviceMain();
  }

  // 继续任务
  Future<void> continueTask(String gid) async {
    await Requests().continueTask(gid);
    serviceMain();
  }

  // 多任务暂停
  Future<void> multiPause(List ls) async {
    for (var item in ls) {
      await Requests().pauseTask(item);
    }
    serviceMain();
  }

  // 多任务继续
  Future<void> multiContinue(List ls) async {
    for (var item in ls) {
      await Requests().continueTask(item);
    }
    serviceMain();
  }

  // 多任务移除
  Future<void> multiRemove(List ls) async {
    for (var item in ls) {
      await Requests().removeTask(item);
    }
    serviceMain();
  }

  // 移除已完成的任务
  Future<void> removeFinishedTask(String gid) async {
    await Requests().removeFinishedTask(gid);
    serviceMain();
  }

  // 多任务（已完成）移除
  Future<void> multiRemoveFinishedTask(List ls) async {
    for (var item in ls) {
      await Requests().removeFinishedTask(item);
    }
    serviceMain();
  }

  // 暂停所有任务
  Future<void> pauseAll() async {
    await Requests().pauseAll();
    serviceMain();
  }

  // 继续所有任务
  Future<void> continueAll() async {
    await Requests().continueAll();
    serviceMain();
  }

  // 清空所有已完成的任务
  Future<void> clearFinished() async {
    await Requests().clearFinished();
    serviceMain();
  }

  // 获取全局设置
  Future<void> getGlobalSettings() async {
    Map? data=await Requests().getGlobalSettings();
    if(data!=null){
      s.settings.value=data;
      s.settings.refresh();
    }
  }

  // 保存设置
  Future<void> savePrefs(Map settings) async{
    await Requests().changeGlobalSettings(settings);
  }
}