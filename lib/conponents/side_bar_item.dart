import 'package:aria_ui/variables/page_var.dart';
import 'package:aria_ui/variables/setting_var.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class SideBarItem extends StatefulWidget {

  final String name;
  final IconData icon;

  const SideBarItem({super.key, required this.name, required this.icon});

  @override
  State<SideBarItem> createState() => _SideBarItemState();
}

class _SideBarItemState extends State<SideBarItem> {

  PageVar p=Get.put(PageVar());
  SettingVar s=Get.put(SettingVar());
  bool hover=false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.name=='折叠'){
          p.fold.value=!p.fold.value;
        }else if(widget.name=='关于'){
          showDialog(
            context: context, 
            builder: (context)=>ContentDialog(
              title: Text('关于Aria UI', style: GoogleFonts.notoSansSc(),),
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
                    s.version,
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
        }else{
          p.nowPage.value=widget.name;
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_){
          setState(() {
            hover=true;
          });
        },
        onExit: (_){
          setState(() {
            hover=false;
          });
        },
        child: Stack(
          children: [
            Obx(()=>
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: 0,
                right: widget.name=='折叠' ? 95 : p.fold.value ? 95 : 0,
                top: 0,
                bottom: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: p.nowPage.value==widget.name || hover? const Color.fromARGB(255, 234, 234, 234) : const Color.fromARGB(0, 234, 234, 234),
                  ),
                )
              ),
            ),
            Obx(()=>
              Positioned(
                top: 10,
                left: 0,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: p.nowPage.value==widget.name ? Container(
                    key: const ValueKey<int>(0),
                    height: 15,
                    width: 3,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ) : Container(key: const ValueKey<int>(1),),
                )
              )
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5)
              ),
              height: 35,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    FaIcon(
                      widget.icon,
                      size: 14,
                    ),
                    const SizedBox(width: 20,),
                    Text(widget.name=='折叠' ? '' : widget.name)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}