import 'dart:io';

import 'package:aria_ui/conponents/side_bar.dart';
import 'package:aria_ui/funcs/prefs.dart';
import 'package:aria_ui/funcs/services.dart';
import 'package:aria_ui/pages/active.dart';
import 'package:aria_ui/pages/finished.dart';
import 'package:aria_ui/pages/settings.dart';
import 'package:aria_ui/variables/page_var.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> with WindowListener {

  late Worker pagelistener;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Prefs().initPrefs(context);
    });
    pagelistener=ever(p.nowPage, (_){
      Services().serviceMain();
    });
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    pagelistener.dispose();
    Prefs().destroyTimer();
    super.dispose();
  }

  bool maxWindows=false;

  @override
  void onWindowMaximize(){
    setState(() {
      maxWindows=true;
    });
  }

  @override
  void onWindowUnmaximize(){
    setState(() {
      maxWindows=false;
    });
  }

  void closeWindow(){
    windowManager.close();
  }

  void minWindow(){
    windowManager.minimize();
  }
  void maxWindow(){
    windowManager.maximize();
  }
  
  void unmaxWindow(){
    windowManager.unmaximize();
  }

  PageVar p=Get.put(PageVar());

  int getPageIndex(String page) {
    switch (page) {
      case '活跃中':
        return 0;
      case '已完成':
        return 1;
      case '设置':
        return 2;
      default:
        return 0;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 243, 243, 243),
      child: Column(
        children: [
          Container(
            height: 40,
            color: Colors.transparent,
            child: Platform.isWindows ? Row(
              children: [
                Expanded(child: DragToMoveArea(child: Container())),
                WindowCaptionButton.minimize(onPressed: minWindow,),
                maxWindows ? WindowCaptionButton.unmaximize(onPressed: unmaxWindow) : WindowCaptionButton.maximize(onPressed: maxWindow,),
                WindowCaptionButton.close(onPressed: (){
                  closeWindow();
                },)
              ],
            ) : DragToMoveArea(child: Container())
          ),
          Expanded(
            child: Stack(
              children: [
                const SideBar(),
                Obx(()=>
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: p.fold.value ? 50 : 150,
                    right: 10,
                    bottom: 10,
                    top: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 250, 250, 250),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            spreadRadius: 1,
                            blurRadius: 1,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Obx(()=>
                        IndexedStack(
                          index: getPageIndex(p.nowPage.value),
                          children: const [
                            ActiveView(),
                            FinishedView(),
                            SettingsView(),
                          ],
                        )
                      )
                    ), 
                  )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}