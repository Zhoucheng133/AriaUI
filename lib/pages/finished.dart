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

class FinishedView extends StatefulWidget {
  const FinishedView({super.key});

  @override
  State<FinishedView> createState() => _FinishedViewState();
}

class _FinishedViewState extends State<FinishedView> {

  final TaskVar t=Get.put(TaskVar());
  bool select=false;
  
  List selectList=[];

  ScrollController controller=ScrollController();

  void clear(){
    showDialog(
      context: context, 
      builder: (context)=>ContentDialog(
        title: Text('清空所有已完成任务', style: GoogleFonts.notoSansSc(),),
        content: Text('确定要清空所有已完成的任务吗? 这个操作不可撤销!', style: GoogleFonts.notoSansSc(),),
        actions: [
          Button(
            child: Text('取消', style: GoogleFonts.notoSansSc(),), 
            onPressed: (){
              Navigator.pop(context);
            }
          ),
          FilledButton(
            child: Text('继续', style: GoogleFonts.notoSansSc()), 
            onPressed: (){
              Services().clearFinished();
              Navigator.pop(context);
            }
          )
        ],
      )
    );
  }
  
  void selectMode(){
    setState(() {
      selectList=[];
      select=!select;
    });
  }

  void removeTask(){
    
  }

  void changeSelectStatus(String gid){
    if(selectList.contains(gid)){
      setState(() {
        selectList.remove(gid);
      });
    }else{
      setState(() {
        selectList.add(gid);
      });
    }
  }

  bool checked(String gid){
    return selectList.contains(gid);
  }

  bool menuEnabled(){
    if(select && selectList.isNotEmpty){
      return true;
    }
    return false;
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        children: [
          Row(
            children: [
              MenuButton(icon: FontAwesomeIcons.squareCheck, name: '选择', func: ()=>selectMode()),
              SizedBox(width: 10,),
              MenuButton(icon: FontAwesomeIcons.trash, name: '移除', func: ()=>removeTask(), enable: menuEnabled(),),
              SizedBox(width: 10,),
              MenuButton(icon: FontAwesomeIcons.trash, name: '清空列表', func: ()=>clear()),
              SizedBox(width: 10,),
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
                    itemCount: t.stopped.length,
                    itemBuilder: (BuildContext context, int index){
                      String name='';
                      String dir='';
                      int completedLength=0;
                      int totalLength=0;
                      int downloadSpeed=0;
                      String gid='';
                      dir=t.stopped[index]['dir'];
                      String status='';
                      completedLength=int.parse(t.stopped[index]['completedLength']);
                      totalLength=int.parse(t.stopped[index]['totalLength']);
                      downloadSpeed=int.parse(t.stopped[index]['downloadSpeed']);
                      gid=t.stopped[index]['gid'];
                      status=t.stopped[index]['status'];
                      try {
                        name=t.stopped[index]['bittorrent']['info']['name'];
                      } catch (_) {
                        name=p.basename(t.stopped[index]['files'][0]['path']);
                      }
                      return TaskItem(name: name, totalLength: totalLength, completedLength: completedLength, dir: dir, downloadSpeed: downloadSpeed, gid: gid, status: status, selectMode: select, changeSelectStatus: ()=>changeSelectStatus(gid), checked: checked(gid),);
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