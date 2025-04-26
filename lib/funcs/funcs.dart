import 'package:aria_ui/variables/setting_var.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart' show showLicensePage;

class Funcs {

  SettingVar s=Get.find();
  

  void showAbout(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if(context.mounted){
      showDialog(
        context: context, 
        builder: (context)=>ContentDialog(
          title: Text('关于AriaUI', style: GoogleFonts.notoSansSc(),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/icon.png')
                ),
              ),
              Text(
                'Aria UI', 
                style: GoogleFonts.notoSansSc(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                'v${packageInfo.version}',
                style: GoogleFonts.notoSansSc(
                  color: Colors.grey[80],
                ),
              ),
              const SizedBox(height: 15,),
              GestureDetector(
                onTap: () async {
                  final Uri url = Uri.parse('https://github.com/Zhoucheng133/AriaUI');
                  await launchUrl(url);
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.github,
                        size: 15,
                      ),
                      const SizedBox(width: 5,),
                      Text(
                        '本项目地址',
                        style:  GoogleFonts.notoSansSc(
                  
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: ()=>showLicensePage(
                  context: context,
                  applicationName: 'AriaUI',
                  applicationVersion: 'v${packageInfo.version}'
                ),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.certificate,
                        size: 15,
                      ),
                      const SizedBox(width: 5,),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          '许可证',
                          style: GoogleFonts.notoSansSc(
                            fontSize: 13,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
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
  }
}