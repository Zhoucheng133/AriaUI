// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aria_ui/conponents/setting_item.dart';
import 'package:aria_ui/funcs/prefs.dart';
import 'package:aria_ui/variables/setting_var.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  TextEditingController rpc=TextEditingController();
  TextEditingController secret=TextEditingController();
  final SettingVar s=Get.put(SettingVar());

  @override
  void initState() {
    super.initState();
    if(s.rpc.value.isNotEmpty){
      rpc.text=s.rpc.value;
    }
    if(s.secret.value.isNotEmpty){
      secret.text=s.secret.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20,),
        SettingItem(
          label: 'RPC地址', 
          item: TextBox(
            controller: rpc,
            placeholder: 'http(s)://',
            autocorrect: false,
            enableSuggestions: false,
            style: GoogleFonts.notoSansSc(),
          )
        ),
        SizedBox(height: 10,),
        SettingItem(
          label: 'RPC密钥',
          item: TextBox(
            controller: secret,
            autocorrect: false,
            enableSuggestions: false,
            obscureText: true,
            style: GoogleFonts.notoSansSc(),
          )
        ),
        Expanded(child: Container()),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Button(
              child: Text('放弃保存', style: GoogleFonts.notoSansSc(),),
              onPressed: (){
                showDialog(
                  context: context, 
                  builder: (context)=>ContentDialog(
                    title: Text('放弃保存?', style: GoogleFonts.notoSansSc(),),
                    content: Text('这不会保留你的所有修改', style: GoogleFonts.notoSansSc(),),
                    actions: [
                      Button(
                        child: Text('取消', style: GoogleFonts.notoSansSc(),), 
                        onPressed: (){
                          Navigator.pop(context);
                        }
                      ),
                      FilledButton(
                        child: Text('放弃', style: GoogleFonts.notoSansSc(),),
                        onPressed: (){
                          rpc.text=s.rpc.value;
                          secret.text=s.secret.value;
                          Navigator.pop(context);
                        }
                      )
                    ],
                  )
                );
              }
            ),
            SizedBox(width: 10,),
            FilledButton(
              child: Text('保存', style: GoogleFonts.notoSansSc(),), 
              onPressed: () async {
                Prefs().setPrefs(rpc.text, secret.text);
                await displayInfoBar(
                  context, 
                  builder: (context, close) => InfoBar(
                    title: Text('保存设置成功', style: GoogleFonts.notoSansSc(),),
                    severity: InfoBarSeverity.success,
                  )
                );
                // Navigator.pop(context);
              }
            )
          ],
        ),
        SizedBox(height: 30,)
      ],
    );
  }
}