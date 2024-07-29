
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aria_ui/conponents/menu_button.dart';
import 'package:aria_ui/conponents/task_item.dart';
import 'package:aria_ui/funcs/services.dart';
import 'package:aria_ui/variables/task_var.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as p;

class ActiveView extends StatefulWidget {
  const ActiveView({super.key});

  @override
  State<ActiveView> createState() => _ActiveViewState();
}

class _ActiveViewState extends State<ActiveView> {

  void addTask(){
    TextEditingController controller=TextEditingController();
    showDialog(
      context: context, 
      builder: (content)=>ContentDialog(
        title: Text('添加任务', style: GoogleFonts.notoSansSc(),),
        content: SizedBox(
          height: 100,
          child: TextBox(
            maxLines: null,
            controller: controller,
            placeholder: 'http(s)://\nmagnet:',
            textAlignVertical: TextAlignVertical.top,
          ),
        ),
        actions: [
          Button(
            child: Text('取消', style: GoogleFonts.notoSansSc(),), 
            onPressed: (){
              Navigator.pop(context);
            }
          ),
          FilledButton(
            child: Text('添加', style: GoogleFonts.notoSansSc(),), 
            onPressed: (){
              Services().addTask(controller.text);
              Navigator.pop(context);
            }
          )
        ],
      )
    );
  }

  void selectMode(){
    // TODO 选择
  }

  void selectAll(){
    // TODO 全选
  }

  void continueTask(){
    // TODO 继续
  }

  void pauseTask(){
    // TODO 暂停
  }

  void removeTask(){
    // TODO 移除
  }

  final TaskVar t=Get.put(TaskVar());

  ScrollController controller=ScrollController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        children: [
          Row(
            children: [
              MenuButton(icon: FontAwesomeIcons.plus, name: '添加', func: ()=>addTask()),
              SizedBox(width: 10,),
              MenuButton(icon: FontAwesomeIcons.squareCheck, name: '选择', func: ()=>selectMode()),
              SizedBox(width: 10,),
              MenuButton(icon: FontAwesomeIcons.list, name: '全选', func: ()=>selectAll()),
              SizedBox(width: 10,),
              MenuButton(icon: FontAwesomeIcons.play, name: '继续', func: ()=>continueTask(), enable: false,),
              SizedBox(width: 10,),
              MenuButton(icon: FontAwesomeIcons.pause, name: '暂停', func: ()=>pauseTask(), enable: false,),
              SizedBox(width: 10,),
              MenuButton(icon: FontAwesomeIcons.trash, name: '移除', func: ()=>removeTask(), enable: false,),
            ],
          ),
          const SizedBox(height: 5,),
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 234, 234, 234),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Scrollbar(
              controller: controller,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: Obx(()=>
                  ListView.builder(
                    controller: controller,
                    itemCount: t.active.length,
                    itemBuilder: (BuildContext context, int index){
                      String name='';
                      String dir='';
                      int completedLength=0;
                      int totalLength=0;
                      int downloadSpeed=0;
                      String gid='';
                      String status='';
                      dir=t.active[index]['dir'];
                      completedLength=int.parse(t.active[index]['completedLength']);
                      totalLength=int.parse(t.active[index]['totalLength']);
                      downloadSpeed=int.parse(t.active[index]['downloadSpeed']);
                      gid=t.active[index]['gid'];
                      status=t.active[index]['status'];
                      try {
                        name=t.active[index]['bittorrent']['info']['name'];
                      } catch (_) {
                        name=p.basename(t.active[index]['files'][0]['path']);
                      }
                      return TaskItem(name: name, totalLength: totalLength, completedLength: completedLength, dir: dir, downloadSpeed: downloadSpeed, gid: gid, status: status,);
                    }
                  )
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}