// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aria_ui/conponents/setting_item.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  TextEditingController rpc=TextEditingController();
  TextEditingController secret=TextEditingController();

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
              child: const Text('放弃保存'), 
              onPressed: (){
                // TODO 放弃保存
              }
            ),
            SizedBox(width: 10,),
            FilledButton(
              child: const Text('保存'), 
              onPressed: (){
                // TODO 保存设置
              }
            )
          ],
        ),
        SizedBox(height: 30,)
      ],
    );
  }
}