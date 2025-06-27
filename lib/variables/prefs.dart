import 'package:aria_ui/funcs/services.dart';
import 'package:aria_ui/variables/page_var.dart';
import 'package:aria_ui/variables/setting_var.dart';
import 'package:aria_ui/variables/task_var.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsVar extends GetxController{
  late SharedPreferences prefs;
  final SettingVar s=Get.find();
  final PageVar p=Get.find();
  final TaskVar t=Get.find();

  Future<void> saveAppPrefs() async {
    prefs=await SharedPreferences.getInstance();
    prefs.setInt('defaultActiveOrder', s.defaultActiveOrder.value.index);
    prefs.setInt('defaultFinishedOrder', s.defaultFinishedOrder.value.index);
  }

  Future<void> initPrefs(BuildContext context) async {
    prefs=await SharedPreferences.getInstance();
    String? rpc=prefs.getString('rpc');
    String? secret=prefs.getString('secret');
    int? defaultActiveOrder=prefs.getInt('defaultActiveOrder');
    int? defaultFinishedOrder=prefs.getInt('defaultFinishedOrder');
    if(defaultActiveOrder!=null){
      s.defaultActiveOrder.value=Order.values[defaultActiveOrder];
      p.activeOrder.value=Order.values[defaultActiveOrder];
    }
    if(defaultFinishedOrder!=null){
      s.defaultFinishedOrder.value=Order.values[defaultFinishedOrder];
      p.finishedOrder.value=Order.values[defaultFinishedOrder];
    }
    if(rpc!=null && secret!=null){
      s.rpc.value=rpc;
      s.secret.value=secret;
      if(context.mounted){
        Services().startService(context);
      }
      await Services().getGlobalSettings();
    }else{
      if(context.mounted){
        showDialog(
          context: context, 
          builder: (BuildContext context)=>ContentDialog(
            title: Text('需要配置RPC', style: GoogleFonts.notoSansSc(),),
            content: Text('你可以前往设置页进行配置', style: GoogleFonts.notoSansSc(),),
            actions: [
              Button(
                onPressed: (){
                  t.activeInit.value=false;
                  t.stoppedInit.value=false;
                  Navigator.pop(context);
                },
                child: Text('好的', style: GoogleFonts.notoSansSc(),)
              ),
              FilledButton(
                child: Text('设置', style: GoogleFonts.notoSansSc(),), 
                onPressed: (){
                  Navigator.pop(context);
                  s.setRPC(context);
                }
              )
            ],
          )
        );
      }
    }
  }

  void destroyTimer(){
    Services().destoryServive();
  }

  Future<void> setPrefs(String rpc, String secret) async {
    s.rpc.value=rpc;
    s.secret.value=secret;
    prefs=await SharedPreferences.getInstance();
    prefs.setString('rpc', rpc);
    prefs.setString('secret', secret);
  }
}