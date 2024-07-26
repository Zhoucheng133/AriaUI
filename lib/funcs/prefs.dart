import 'package:aria_ui/variables/page_var.dart';
import 'package:aria_ui/variables/setting_var.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs{
  late SharedPreferences prefs;
  final SettingVar s=Get.put(SettingVar());
  final PageVar p=Get.put(PageVar());

  Future<void> initPrefs(BuildContext context) async {
    prefs=await SharedPreferences.getInstance();
    String? rpc=prefs.getString('rpc');
    String? secret=prefs.getString('secret');
    if(rpc!=null && secret!=null){
      s.rpc.value=rpc;
      s.secret.value=secret;
    }else{
      if(context.mounted){
        showDialog(
          context: context, 
          builder: (BuildContext context)=>ContentDialog(
            title: const Text('需要配置RPC'),
            content: const Text('你可以前往设置页进行配置'),
            actions: [
              Button(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text('好的')
              ),
              FilledButton(
                child: const Text('前往设置'), 
                onPressed: (){
                  p.nowPage.value='设置';
                  Navigator.pop(context);
                }
              )
            ],
          )
        );
      }
    }
  }
}