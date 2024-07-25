import 'dart:io';

import 'package:aria_ui/variables/static_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: StaticColors().color1,
      child: Column(
        children: [
          Container(
            height: 30,
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
            child: Row(
              children: [
                SizedBox(
                  width: 150,
                  child: Container(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10, top: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container()
                    ),
                  )
                )
              ],
            ),
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }
}