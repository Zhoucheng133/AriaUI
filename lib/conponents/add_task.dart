import 'package:aria_ui/funcs/services.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:google_fonts/google_fonts.dart';

void addTask(BuildContext context){

  TextEditingController controller=TextEditingController();
  bool manual=false;

  showDialog(
    context: context, 
    builder: (content)=>ContentDialog(
      title: Text('添加任务', style: GoogleFonts.notoSansSc(),),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 100,
                child: TextBox(
                  maxLines: null,
                  controller: controller,
                  placeholder: 'http(s)://\nmagnet:',
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.centerLeft,
                child: Checkbox(
                  checked: manual, 
                  onChanged: (val){
                    setState((){
                      manual=val??false;
                    });
                  },
                  content: Text('使用自定义配置', style: GoogleFonts.notoSansSc(),),
                ),
              ),
              // manual ? const Text(
              //   '下载地址'
              // ) : Container()
              manual ? SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5,),
                    Text('下载地址', style: GoogleFonts.notoSansSc(),)
                  ],
                ),
              ) : Container()
            ],
          );
        }
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