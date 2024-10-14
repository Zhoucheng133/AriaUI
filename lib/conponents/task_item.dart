import 'package:aria_ui/conponents/task_button.dart';
import 'package:aria_ui/funcs/services.dart';
import 'package:aria_ui/variables/page_var.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';

class TaskItem extends StatefulWidget {

  final String name;
  final int totalLength;
  final int completedLength; 
  final String dir;
  final int downloadSpeed;
  final dynamic uploadSpeed;
  final String gid;
  final String status;
  final bool selectMode;
  final VoidCallback changeSelectStatus;
  final bool checked;

  const TaskItem({super.key, required this.name, required this.totalLength, required this.completedLength, required this.dir, required this.downloadSpeed, required this.gid, required this.status, required this.selectMode, required this.changeSelectStatus, required this.checked, this.uploadSpeed});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  PageVar p=Get.put(PageVar());

  String convertSize(int bytes) {
    try {
      if (bytes < 0) return 'Invalid value';
      const List<String> units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
      int unitIndex = max(0, min(units.length - 1, (log(bytes) / log(1024)).floor()));
      double value = bytes / pow(1024, unitIndex);
      String formattedValue = value % 1 == 0 ? '$value' : value.toStringAsFixed(2);
      return '$formattedValue ${units[unitIndex]}';
    } catch (_) {
      return '';
    }
  }

  bool hover=false;

  void activeItem(){
    Services().continueTask(widget.gid);
  }

  void pauseItem(){
    Services().pauseTask(widget.gid);
  }

  void delItem(){
    showDialog(
      context: context, 
      builder: (context)=>ContentDialog(
        title: Text('移除任务', style: GoogleFonts.notoSansSc(),),
        content: Text('确定要移除任务吗，移除的任务会放在已完成的任务中', style: GoogleFonts.notoSansSc(),),
        actions: [
          Button(
            child: Text('取消', style: GoogleFonts.notoSansSc(),), 
            onPressed: (){
              Navigator.pop(context);
            }
          ),
          FilledButton(
            child: Text('确定', style: GoogleFonts.notoSansSc(),), 
            onPressed: (){
              if(p.nowPage.value=='已完成'){
                Services().removeFinishedTask(widget.gid);
              }else{
                Services().remove(widget.gid);
              }
              
              Navigator.pop(context);
            }
          )
        ],
      )
    );
  }

  String formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');

    // 如果有小时数，则显示小时部分
    if (hours > 0) {
      String formattedHours = hours.toString();
      return '$formattedHours:$formattedMinutes:$formattedSeconds';
    } else {
      return '$formattedMinutes:$formattedSeconds';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
      child: GestureDetector(
        onTap: (){
          if(widget.selectMode){
            widget.changeSelectStatus();
          }
        },
        child: AnimatedContainer(
          decoration: BoxDecoration(
            color: hover ? const Color.fromARGB(255, 240, 240, 240) : const Color.fromARGB(0, 240, 240, 240)
          ),
          duration: const Duration(milliseconds: 200),
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: Row(
              children: [
                widget.selectMode? SizedBox(
                  width: 40,
                  child: Center(
                    child: Checkbox(
                      checked: widget.checked, 
                      onChanged: (_){
                        widget.changeSelectStatus();
                      }
                    ),
                  ),
                ):Container(),
                Flexible(
                  flex: 3,
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5,),
                        Text(
                          convertSize(widget.totalLength),
                          style: GoogleFonts.notoSansSc(
                            fontSize: 12
                          ),
                        )
                      ],
                    ),
                  )
                ),
                const SizedBox(width: 10,),
                Flexible(
                  flex: 2,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ProgressBar(
                          activeColor: (widget.completedLength/widget.totalLength)==1 ? Colors.green.lighter : Colors.teal,
                          value: widget.totalLength==0 ? 0 : (widget.completedLength/widget.totalLength)*100
                        )
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${ widget.totalLength==0 ? 0 : ((widget.completedLength/widget.totalLength)*100).toStringAsFixed(2)}%',
                              style: GoogleFonts.notoSansSc(
                                fontSize: 12
                              ),
                            ),
                          ),
                          widget.uploadSpeed!=null && p.nowPage.value=='活跃中' ? Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              widget.uploadSpeed!=0 ? const FaIcon(
                                size: 12,
                                FontAwesomeIcons.arrowUp
                              ) : Container(),
                              const SizedBox(width: 3,),
                              Text(
                                widget.uploadSpeed==0 ? '' : '${convertSize(widget.uploadSpeed)}/s',
                                style: GoogleFonts.notoSansSc(
                                  fontSize: 12
                                ),
                              ),
                            ],
                          ):Container(),
                          const SizedBox(width: 10,),
                          p.nowPage.value=='活跃中' ? Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.arrowDown,
                                size: 12,
                              ),
                              const SizedBox(width: 3,),
                              Text(
                                widget.downloadSpeed==0 ? '0 B/s' : '${convertSize(widget.downloadSpeed)}/s',
                                style: GoogleFonts.notoSansSc(
                                  fontSize: 12
                                ),
                              ),
                              (widget.completedLength/widget.totalLength)!=1.0 ? Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  formatDuration(widget.totalLength~/widget.downloadSpeed),
                                  style: GoogleFonts.notoSansSc(
                                    fontSize: 12
                                  ),
                                ),
                              ):Container()
                            ],
                          ) : Container()
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                widget.status=='active' ? TaskButton(gid: widget.gid, func: ()=>pauseItem(), icon: FluentIcons.pause, hint: '暂停', enabled: true,) :
                widget.status=='paused' ? TaskButton(gid: widget.gid, func: ()=>activeItem(), icon: FluentIcons.play, hint: '继续', enabled: true,) :
                TaskButton(gid: widget.gid, func: ()=>pauseItem(), icon: FluentIcons.pause, hint: '暂停', enabled: false,),
                const SizedBox(width: 10,),
                TaskButton(gid: widget.gid, func: ()=>delItem(), icon:FluentIcons.delete, hint: '删除', enabled: true,),
                const SizedBox(width: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}