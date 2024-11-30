import 'package:aria_ui/funcs/services.dart';
import 'package:aria_ui/variables/page_var.dart';
import 'package:aria_ui/variables/setting_var.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs{
  late SharedPreferences prefs;
  final SettingVar s=Get.put(SettingVar());
  final PageVar p=Get.put(PageVar());

  Future<void> saveAppPrefs() async {
    prefs=await SharedPreferences.getInstance();
    prefs.setInt('defaultOrder', s.defaultOrder.value.index);
  }

  Future<void> initPrefs(BuildContext context) async {
    prefs=await SharedPreferences.getInstance();
    String? rpc=prefs.getString('rpc');
    String? secret=prefs.getString('secret');
    int? defaultOrder=prefs.getInt('defaultOrder');
    if(defaultOrder!=null){
      s.defaultOrder.value=Order.values[defaultOrder];
      p.activeOrder.value=Order.values[defaultOrder];
      p.finishedOrder.value=Order.values[defaultOrder];
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
                  Navigator.pop(context);
                },
                child: Text('好的', style: GoogleFonts.notoSansSc(),)
              ),
              FilledButton(
                child: Text('前往设置', style: GoogleFonts.notoSansSc(),), 
                onPressed: (){
                  p.nowPage.value=Pages.settings;
                  Navigator.pop(context);
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