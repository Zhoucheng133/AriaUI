import 'package:aria_ui/conponents/task_button.dart';
import 'package:aria_ui/funcs/services.dart';
import 'package:aria_ui/request/requests.dart';
import 'package:aria_ui/variables/page_var.dart';
import 'package:aria_ui/variables/task_var.dart';
import 'package:clipboard/clipboard.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:path/path.dart' as path;

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
  final bool active;
  final int index;

  const TaskItem({super.key, required this.name, required this.totalLength, required this.completedLength, required this.dir, required this.downloadSpeed, required this.gid, required this.status, required this.selectMode, required this.changeSelectStatus, required this.checked, this.uploadSpeed, required this.active, required this.index});

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
      return '0 B';
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
        content: Text('确定要移除任务吗', style: GoogleFonts.notoSansSc(),),
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
              if(p.nowPage.value==Pages.finished){
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

  final TaskVar t=Get.put(TaskVar());

  void showFiles(BuildContext context){

    List list=[];
    for (var item in widget.active ? t.active[widget.index]['files']??[] : t.stopped[widget.index]['files']??[]) {
      String name="";
      try {
        name=item['path']==null ? "" : path.basename(item['path']);
      } catch (_) {}
      String size='0 B';
      try {
        int length=int.parse(item['length']);
        size=convertSize(length);
      } catch (_) {}
      list.add({
        'name': name,
        'size': size,
      });
    }

    showDialog(
      context: context, 
      builder: (context)=>ContentDialog(
        title: Text('文件列表', style: GoogleFonts.notoSansSc(),),
        content: SizedBox(
          height: 400,
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index){
              return Tooltip(
                message: list[index]['name'],
                useMousePosition: false,
                child: SizedBox(
                  height: 30,
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            list[index]['name'],
                            style: GoogleFonts.notoSansSc(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            list[index]['size'],
                            style: GoogleFonts.notoSansSc(),
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          ),
        ),
        actions: [
          FilledButton(
            onPressed: ()=>Navigator.pop(context),
            child: Text('完成', style: GoogleFonts.notoSansSc(),)
          )
        ],
        constraints: const BoxConstraints(
          minWidth: 600,
          maxWidth: 600
        ),
      ),
    );
  }
  
  void showDetail(BuildContext context){
    showDialog(
      context: context, 
      builder: (context)=>ContentDialog(
        title: Text('任务详情', style: GoogleFonts.notoSansSc(),),
        content: Obx(()=>
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text('任务名称', style: GoogleFonts.notoSansSc(),),
                  ),
                  Expanded(
                    child: Text(
                      widget.name, 
                      style: GoogleFonts.notoSansSc(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text('下载路径', style: GoogleFonts.notoSansSc(),),
                  ),
                  Expanded(
                    child: Text(
                      widget.active ? t.active[widget.index]['dir']??'' : t.stopped[widget.index]['dir']??'', 
                      style: GoogleFonts.notoSansSc(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text('任务状态', style: GoogleFonts.notoSansSc(),),
                  ),
                  Expanded(
                    child: Text(
                      widget.active ? t.active[widget.index]['status']??'' : t.stopped[widget.index]['status']??'', 
                      style: GoogleFonts.notoSansSc(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text('总大小', style: GoogleFonts.notoSansSc(),),
                  ),
                  Expanded(
                    child: Text(
                      widget.active ? convertSize(int.parse(t.active[widget.index]['totalLength']??'0')) : convertSize(int.parse(t.stopped[widget.index]['totalLength']??'0')), 
                      style: GoogleFonts.notoSansSc(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text('已完成大小', style: GoogleFonts.notoSansSc(),),
                  ),
                  Expanded(
                    child: Text(
                      widget.active ? convertSize(int.parse(t.active[widget.index]['completedLength']??'0')) : convertSize(int.parse(t.stopped[widget.index]['completedLength']??'0')), 
                      style: GoogleFonts.notoSansSc(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text('已上传大小', style: GoogleFonts.notoSansSc(),),
                  ),
                  Expanded(
                    child: Text(
                      widget.active ? convertSize(int.parse(t.active[widget.index]['uploadLength']??'0')) : convertSize(int.parse(t.stopped[widget.index]['uploadLength']??'0')), 
                      style: GoogleFonts.notoSansSc(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text('正在做种', style: GoogleFonts.notoSansSc(),),
                  ),
                  Expanded(
                    child: Text(
                      widget.active ? t.active[widget.index]['seeder']??'false' : 'false', 
                      style: GoogleFonts.notoSansSc(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        actions: [
          Button(
            onPressed: (){
              Navigator.pop(context);
              showFiles(context);
            },
            child: Text('文件信息', style: GoogleFonts.notoSansSc(),)
          ),
          FilledButton(
            onPressed: ()=>Navigator.pop(context),
            child: Text('完成', style: GoogleFonts.notoSansSc(),)
          )
        ],
      )
    );
  }

  void copyLink(){
    final item=widget.active ? t.active[widget.index] : t.stopped[widget.index];
    final uris=item['files'][0]['uris'];
    final infoHash=item['infoHash'];
    if(uris.length==0){
      FlutterClipboard.copy('magnet:?xt=urn:btih:$infoHash');
    }else{
      FlutterClipboard.copy(uris[0]['uri']);
    }
  }

  void reAddTask(){
    final item=widget.active ? t.active[widget.index] : t.stopped[widget.index];
    final uris=item['files'][0]['uris'];
    final infoHash=item['infoHash'];
    if(uris.length==0){
      Requests().addTask('magnet:?xt=urn:btih:$infoHash');
    }else{
      Requests().addTask(uris[0]['uri']);
    }
    if(p.nowPage.value==Pages.finished){
      Services().removeFinishedTask(widget.gid);
    }else{
      Services().remove(widget.gid);
    }
  }

  final contextController = FlyoutController();
  final contextAttachKey = GlobalKey();
  
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
      child: Tooltip(
        message: widget.name,
        useMousePosition: true,
        child: FlyoutTarget(
          key: contextAttachKey,
          controller: contextController,
          child: GestureDetector(
            onTap: (){
              if(widget.selectMode){
                widget.changeSelectStatus();
              }else{
                showDetail(context);
              }
            },
            onSecondaryTapDown: (d){
              final targetContext = contextAttachKey.currentContext;
              if (targetContext == null) return;
              final box = targetContext.findRenderObject() as RenderBox;
              final position = box.localToGlobal(
                d.localPosition,
                ancestor: Navigator.of(context).context.findRenderObject(),
              );
              contextController.showFlyout(
                barrierColor: Colors.black.withOpacity(0.1),
                position: position,
                builder: (context) {
                  return MenuFlyout(
                    items: [
                      MenuFlyoutItem(
                        leading: const Icon(FluentIcons.info),
                        text: Text('任务详情', style: GoogleFonts.notoSansSc()),
                        onPressed: (){
                          Flyout.of(context).close();
                          showDetail(context);
                        },
                      ),
                      MenuFlyoutItem(
                        leading: const Icon(FluentIcons.bulleted_list),
                        text: Text('文件列表', style: GoogleFonts.notoSansSc()),
                        onPressed: (){
                          Flyout.of(context).close();
                          showFiles(context);
                        }
                      ),
                      MenuFlyoutItem(
                        leading: const Icon(FluentIcons.paste),
                        text: Text('复制链接', style: GoogleFonts.notoSansSc()),
                        onPressed: ()=>copyLink()
                      ),
                      if(widget.status=='active') MenuFlyoutItem(
                        leading: const Icon(FluentIcons.pause),
                        text: Text('暂停', style: GoogleFonts.notoSansSc(),),
                        onPressed: (){
                          Flyout.of(context).close();
                          pauseItem();
                        },
                      ),
                      if(widget.status=='paused') MenuFlyoutItem(
                        leading: const Icon(FluentIcons.play),
                        text: Text('继续', style: GoogleFonts.notoSansSc()),
                        onPressed: (){
                          Flyout.of(context).close();
                          activeItem();
                        },
                      ),
                      if(!widget.active) MenuFlyoutItem(
                        leading: const Icon(FluentIcons.refresh),
                        text: Text('重新下载', style: GoogleFonts.notoSansSc()),
                        onPressed: (){
                          Flyout.of(context).close();
                          reAddTask();
                        }
                      ),
                      MenuFlyoutItem(
                        leading: const Icon(FluentIcons.delete),
                        text: Text('删除', style: GoogleFonts.notoSansSc()),
                        onPressed: (){
                          Flyout.of(context).close();
                          delItem();
                        }
                      ),
                    ],
                  );
                },
              );
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
                              activeColor: widget.completedLength==widget.totalLength ? Colors.green.lighter : widget.active ? Colors.teal : Colors.orange,
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
                              widget.uploadSpeed!=null && p.nowPage.value==Pages.active ? Row(
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
                              p.nowPage.value==Pages.active ? Row(
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
                                      widget.downloadSpeed==0 ? '--:--' : formatDuration(((widget.totalLength - widget.completedLength) > 0 ? widget.totalLength - widget.completedLength : 0)~/widget.downloadSpeed),
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
                    const SizedBox(width: 10,),
                    TaskButton(gid: widget.gid, func: ()=>delItem(), icon:FluentIcons.delete, hint: '删除', enabled: true,),
                    const SizedBox(width: 10,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}