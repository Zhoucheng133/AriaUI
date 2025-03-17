import 'package:aria_ui/conponents/menu_button.dart';
import 'package:aria_ui/conponents/task_item.dart';
import 'package:aria_ui/funcs/services.dart';
import 'package:aria_ui/variables/page_var.dart';
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
  List selectUrl=[];

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
    Services().multiRemoveFinishedTask(selectList);
    selectMode();
  }

  void reDownloadTask(){
    for (var item in selectUrl) {
      Services().addTask(item);
    }
    Services().multiRemoveFinishedTask(selectList);
    selectMode();
  }

  void changeSelectStatus(String gid, int index){
    final item=t.stopped[index];
    final uris=item['files'][0]['uris'];
    final infoHash=item['infoHash'];
    if(selectList.contains(gid)){
      setState(() {
        selectList.remove(gid);
        selectUrl.remove(uris.length==0 ? 'magnet:?xt=urn:btih:$infoHash' : uris[0]['uri']);
      });
    }else{
      setState(() {
        selectList.add(gid);
        selectUrl.add(uris.length==0 ? 'magnet:?xt=urn:btih:$infoHash' : uris[0]['uri']);
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
  final page=Get.put(PageVar());

  void order(){
    Services().tellStopped();
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 35,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                MenuButton(icon: FontAwesomeIcons.squareCheck, name: '选择', func: ()=>selectMode()),
                const SizedBox(width: 10,),
                MenuButton(icon: FontAwesomeIcons.trash, name: '移除', func: ()=>removeTask(), enable: menuEnabled(),),
                const SizedBox(width: 10,),
                MenuButton(icon: FontAwesomeIcons.arrowRotateRight, name: '重试', func: ()=>reDownloadTask(), enable: menuEnabled(),),
                const SizedBox(width: 10,),
                MenuButton(icon: FontAwesomeIcons.trash, name: '清空列表', func: ()=>clear()),
                const SizedBox(width: 10,),
                Obx(()=>
                  ComboBox(
                    value: page.finishedOrder.value,
                    items: [
                      ComboBoxItem(
                        value: Order.oldTime,
                        child:Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FaIcon(FontAwesomeIcons.arrowDownWideShort),
                            const SizedBox(width: 10,),
                            Text('时间顺序', style: GoogleFonts.notoSansSc())
                          ],
                        ),
                      ),
                      ComboBoxItem(
                        value: Order.newTime,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FaIcon(FontAwesomeIcons.arrowDownShortWide),
                            const SizedBox(width: 10,),
                            Text('时间倒序', style: GoogleFonts.notoSansSc())
                          ],
                        ),
                      ),
                      ComboBoxItem(
                        value: Order.titleA,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FaIcon(FontAwesomeIcons.arrowDownAZ),
                            const SizedBox(width: 10,),
                            Text('标题顺序', style: GoogleFonts.notoSansSc())
                          ],
                        ),
                      ),
                      ComboBoxItem(
                        value: Order.titleZ,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FaIcon(FontAwesomeIcons.arrowDownZA),
                            const SizedBox(width: 10,),
                            Text('标题倒序', style: GoogleFonts.notoSansSc())
                          ],
                        ),
                      ),
                    ],
                    onChanged: (val){
                      page.finishedOrder.value=val??Order.newTime;
                      order();
                    },
                  )
                )
              ],
            ),
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
                      return TaskItem(name: name, totalLength: totalLength, completedLength: completedLength, dir: dir, downloadSpeed: downloadSpeed, gid: gid, status: status, selectMode: select, changeSelectStatus: ()=>changeSelectStatus(gid, index), checked: checked(gid), active: false, index: index,);
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