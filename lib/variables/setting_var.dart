import 'package:aria_ui/variables/page_var.dart';
import 'package:aria_ui/variables/prefs.dart';
import 'package:aria_ui/variables/task_var.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingVar extends GetxController{

  RxString rpc=''.obs;
  RxString secret=''.obs;

  var settings={}.obs;

  var defaultActiveOrder=Order.oldTime.obs;
  var defaultFinishedOrder=Order.oldTime.obs;

  void setRPC(BuildContext context){
    TextEditingController rpc=TextEditingController();
    TextEditingController secret=TextEditingController();
    final TaskVar t=Get.find();
    final PrefsVar prefs=Get.find();
    showDialog(
      context: context, 
      builder: (context)=>ContentDialog(
        title: const Text("配置RPC"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text("RPC地址"),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: TextBox(
                        controller: rpc,
                        placeholder: 'http(s)://',
                        autocorrect: false,
                        enableSuggestions: false,
                        style: GoogleFonts.notoSansSc(),
                      )
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    const Text("RPC密钥"),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: TextBox(
                        controller: secret,
                        autocorrect: false,
                        enableSuggestions: false,
                        obscureText: true,
                        style: GoogleFonts.notoSansSc(),
                      )
                    )
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          Button(
            onPressed: (){
              t.activeInit.value=false;
              t.stoppedInit.value=false;
              Navigator.pop(context);
            },
            child: Text('取消', style: GoogleFonts.notoSansSc(),)
          ),
          FilledButton(
            child: Text('完成', style: GoogleFonts.notoSansSc(),), 
            onPressed: () async {
              if(rpc.text.isEmpty || secret.text.isEmpty){
                showDialog(
                  context: context, 
                  builder: (context)=>ContentDialog(
                    title: const Text("配置RPC失败"),
                    content: const Text("RPC地址和密钥不能为空"),
                    actions: [
                      FilledButton(
                        child: const Text("完成"), 
                        onPressed: ()=>Navigator.pop(context)
                      )
                    ],
                  )
                );
              }else{
                this.rpc.value=rpc.text;
                this.secret.value=secret.text;
                await prefs.setPrefs(rpc.text, secret.text);
                if(context.mounted){
                  prefs.initPrefs(context);
                  Navigator.pop(context);
                }
              }
            }
          )
        ],
      )
    );
  }
}