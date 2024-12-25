import 'package:aria_ui/funcs/funcs.dart';
import 'package:aria_ui/variables/page_var.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SideBarItem extends StatefulWidget {

  final Pages name;
  final IconData icon;

  const SideBarItem({super.key, required this.name, required this.icon});

  @override
  State<SideBarItem> createState() => _SideBarItemState();
}

class _SideBarItemState extends State<SideBarItem> {

  PageVar p=Get.put(PageVar());
  bool hover=false;
  Funcs funcs=Funcs();

  String toLabel(){
    switch(widget.name){
      case Pages.about:
        return '关于';
      case Pages.fold:
        return '';
      case Pages.active:
        return '活跃中';
      case Pages.finished:
        return '已完成';
      case Pages.settings:
        return '设置';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.name==Pages.fold){
          p.fold.value=!p.fold.value;
        }else if(widget.name==Pages.about){
          funcs.showAbout(context);
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
                right: widget.name==Pages.fold ? 95 : p.fold.value ? 95 : 0,
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
                    Text(toLabel())
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