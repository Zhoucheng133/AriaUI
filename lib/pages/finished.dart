// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:aria_ui/conponents/task_item.dart';
import 'package:aria_ui/variables/task_var.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

class FinishedView extends StatefulWidget {
  const FinishedView({super.key});

  @override
  State<FinishedView> createState() => _FinishedViewState();
}

class _FinishedViewState extends State<FinishedView> {

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
                      gid=t.active[index]['gid'];
                      status=t.active[index]['status'];
                      try {
                        name=t.stopped[index]['bittorrent']['info']['name'];
                      } catch (_) {
                        name=p.basename(t.stopped[index]['files'][0]['path']);
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