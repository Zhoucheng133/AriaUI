
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aria_ui/conponents/menu_button.dart';
import 'package:aria_ui/conponents/task_item.dart';
import 'package:aria_ui/variables/task_var.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

class ActiveView extends StatefulWidget {
  const ActiveView({super.key});

  @override
  State<ActiveView> createState() => _ActiveViewState();
}

class _ActiveViewState extends State<ActiveView> {

  void addTask(){
    // TODO 添加
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
            child: Obx(()=>
              ListView.builder(
                itemCount: t.active.length,
                itemBuilder: (BuildContext context, int index){
                  String name='';
                  String dir='';
                  int completedLength=0;
                  int totalLength=0;
                  dir=t.active[index]['dir'];
                  completedLength=int.parse(t.active[index]['completedLength']);
                  totalLength=int.parse(t.active[index]['totalLength']);
                  try {
                    name=t.active[index]['bittorrent']['info']['name'];
                  } catch (_) {
                    name=p.basename(t.active[index]['files'][0]['path']);
                  }
                  return TaskItem(name: name, totalLength: totalLength, completedLength: completedLength, dir: dir);
                }
              )
            )
          )
        ],
      ),
    );
  }
}