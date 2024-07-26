import 'dart:io';

import 'package:aria_ui/conponents/side_bar.dart';
import 'package:aria_ui/pages/downloading.dart';
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

  late Worker listener;
  late Worker wsOkListener;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    listener.dispose();
    wsOkListener.dispose();
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
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: p.nowPage.value=='下载中' ? const Downloading() : p.nowPage.value=='已完成' ? const Finished() : const Settings(),
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