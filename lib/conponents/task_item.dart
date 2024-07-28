// ignore_for_file: prefer_const_constructors


import 'package:aria_ui/conponents/task_button.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';

class TaskItem extends StatefulWidget {

  final String name;
  final int totalLength;
  final int completedLength; 
  final String dir;
  final int downloadSpeed;
  final String gid;
  final String status;

  const TaskItem({super.key, required this.name, required this.totalLength, required this.completedLength, required this.dir, required this.downloadSpeed, required this.gid, required this.status});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {

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

  void pauseItem(){
    
  }

  void delItem(){

  }

  void activeItem(){

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
        child: Row(
          children: [
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
                    SizedBox(height: 5,),
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
            SizedBox(width: 10,),
            Flexible(
              flex: 2,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ProgressBar(value: widget.totalLength==0 ? 0 : (widget.completedLength/widget.totalLength)*100)
                  ),
                  SizedBox(height: 5,),
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
                      Text(
                        widget.downloadSpeed==0 ? '0 B/s' : '${convertSize(widget.downloadSpeed)}/s',
                        style: GoogleFonts.notoSansSc(
                          fontSize: 12
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(width: 10,),
            widget.status=='active' ? TaskButton(gid: widget.gid, func: ()=>pauseItem(), icon: FluentIcons.pause, hint: '暂停', enabled: true,) :
            widget.status=='paused' ? TaskButton(gid: widget.gid, func: ()=>activeItem(), icon: FluentIcons.play, hint: '继续', enabled: true,) :
            TaskButton(gid: widget.gid, func: ()=>pauseItem(), icon: FluentIcons.pause, hint: '暂停', enabled: false,),
            SizedBox(width: 10,),
            TaskButton(gid: widget.gid, func: ()=>delItem, icon:FluentIcons.delete, hint: '删除', enabled: true,),
            SizedBox(width: 10,),
          ],
        ),
      ),
    );
  }
}