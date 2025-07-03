import 'dart:convert';
import 'dart:io';

import 'package:aria_ui/funcs/services.dart';
import 'package:aria_ui/variables/setting_var.dart';
import 'package:clipboard/clipboard.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as p;

class AddTask{
  SettingVar s=Get.find();
  TextEditingController controller=TextEditingController();
  TextEditingController dir=TextEditingController();
  TextEditingController userAgent=TextEditingController();
  int downloadLimit=0;

  bool manual=false;
  String filePath="";
  String base64Torrent="";

  bool validLink(String input){
    List urls=input.split("\n");
    for (var url in urls) {
      if(url.startsWith("http://") || url.startsWith("https://") || url.startsWith("magnet:?xt=urn:btih:")){
        return true;
      }
    }
    return false;
  }

  void addHandler(BuildContext context, bool manual){
    if(!validLink(controller.text)){
      showDialog(
        context: context, 
        builder: (context)=>ContentDialog(
          title: const Text('添加失败'),
          content: const Text('任务链接不合法'),
          actions: [
            FilledButton(
              child: const Text("好的"), 
              onPressed: ()=>Navigator.pop(context)
            )
          ],
        )
      );
      return;
    }
    manual ? Services().addManualTask(controller.text, dir.text, userAgent.text, downloadLimit) : Services().addTask(controller.text);
    Navigator.pop(context);
  }

  void addTorrentHandler(BuildContext context, bool manual){
    if(filePath.isEmpty){
      showDialog(
        context: context, 
        builder: (context)=>ContentDialog(
          title: Text("添加任务失败", style: GoogleFonts.notoSansSc(),),
          content: Text("没有选取Torrernt文件", style: GoogleFonts.notoSansSc(),),
          actions: [
            FilledButton(
              child: Text("好的", style: GoogleFonts.notoSansSc(),), 
              onPressed: ()=>Navigator.pop(context)
            )
          ],
        )
      );
      return;
    }
    manual ? Services().addManualTorrentTask(base64Torrent, dir.text, userAgent.text, downloadLimit) : Services().addTorrentTask(base64Torrent);
    Navigator.pop(context);
  }

  Future<void> addTorrent(BuildContext context, dynamic setState) async {
    bool manual=false;
    try {
      dir.text=s.settings['dir'];
    } catch (_) {}
    try {
      userAgent.text=s.settings['user-agent'];
    } catch (_) {}
    try {
      downloadLimit=int.parse(s.settings['max-overall-download-limit']);
    } catch (_) {}
    showDialog(
      context: context, 
      builder: (context)=>ContentDialog(
        title: Text("使用Torrent文件添加任务", style: GoogleFonts.notoSansSc(),),
         constraints: const BoxConstraints(
          minWidth: 500,
          maxWidth: 500,
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        filePath.isEmpty ? "选取文件=>" : p.basename(filePath),
                        style: GoogleFonts.notoSansSc(),
                        overflow: TextOverflow.ellipsis,
                      )
                    ),
                    Button(
                      child: Text("选取文件", style: GoogleFonts.notoSansSc(),), 
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['torrent']
                        );
                        if (result != null) {
                          setState((){
                            filePath=result.files.single.path!;
                          });
                          File file = File(result.files.single.path!);
                          final bytes = await file.readAsBytes();
                          setState((){
                            base64Torrent = base64Encode(bytes);
                          });
                        } else {
                          return;
                        }
                      }
                    )
                  ],
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
                manual ? SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5,),
                      Text('下载地址', style: GoogleFonts.notoSansSc(),),
                      const SizedBox(height: 5,),
                      TextBox(
                        controller: dir,
                      ),
                      const SizedBox(height: 10,),
                      Text('用户代理', style: GoogleFonts.notoSansSc(),),
                      const SizedBox(height: 5,),
                      TextBox(
                        controller: userAgent,
                      ),
                      const SizedBox(height: 10,),
                      Text('下载速度限制', style: GoogleFonts.notoSansSc(),),
                      const SizedBox(height: 5,),
                      NumberBox(
                        value: downloadLimit,
                        mode: SpinButtonPlacementMode.inline,
                        onChanged: (val){
                          if(val!=null){
                            setState(() {
                              downloadLimit=val;
                            });
                          }
                        }
                      )
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
            onPressed: () => Navigator.pop(context)
          ),
          FilledButton(
            child: Text('添加', style: GoogleFonts.notoSansSc(),), 
            onPressed: ()=>addTorrentHandler(context, manual)
          )
        ],
      )
    );
  }

  void addMagnet(BuildContext context, dynamic setState){

    FocusNode node=FocusNode();
    FocusNode inputNode=FocusNode();

    FlutterClipboard.paste().then((value) {
      if(validLink(value)){
        setState((){
          controller.text=value;
        });
      }
    });
    bool manual=false;
    try {
      dir.text=s.settings['dir'];
    } catch (_) {}
    try {
      userAgent.text=s.settings['user-agent'];
    } catch (_) {}
    try {
      downloadLimit=int.parse(s.settings['max-overall-download-limit']);
    } catch (_) {}
    showDialog(
      context: context, 
      builder: (content)=>ContentDialog(
        title: Text('使用磁力链接添加任务', style: GoogleFonts.notoSansSc(),),
        constraints: const BoxConstraints(
          minWidth: 500,
          maxWidth: 500,
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // ignore: use_build_context_synchronously
            Future.microtask(() => FocusScope.of(context).requestFocus(node));
            return KeyboardListener(
              focusNode: node,
              onKeyEvent: (event){
                if(event is KeyDownEvent && event.logicalKey==LogicalKeyboardKey.enter && !inputNode.hasFocus){
                  addHandler(context, manual);
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("若要添加多个任务，用回车拆分", style: GoogleFonts.notoSansSc(),),
                  const SizedBox(height: 10,),
                  SizedBox(
                    height: 100,
                    child: TextBox(
                      focusNode: inputNode,
                      maxLines: null,
                      controller: controller,
                      placeholder: 'http(s)://\nmagnet:?xt=urn:btih:',
                      placeholderStyle: GoogleFonts.notoSansSc(
                        color: Colors.grey[50]
                      ),
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
                  manual ? SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5,),
                        Text('下载地址', style: GoogleFonts.notoSansSc(),),
                        const SizedBox(height: 5,),
                        TextBox(
                          controller: dir,
                        ),
                        const SizedBox(height: 10,),
                        Text('用户代理', style: GoogleFonts.notoSansSc(),),
                        const SizedBox(height: 5,),
                        TextBox(
                          controller: userAgent,
                        ),
                        const SizedBox(height: 10,),
                        Text('下载速度限制', style: GoogleFonts.notoSansSc(),),
                        const SizedBox(height: 5,),
                        NumberBox(
                          value: downloadLimit,
                          mode: SpinButtonPlacementMode.inline,
                          onChanged: (val){
                            if(val!=null){
                              setState(() {
                                downloadLimit=val;
                              });
                            }
                          }
                        )
                      ],
                    ),
                  ) : Container()
                ],
              ),
            );
          }
        ),
        actions: [
          Button(
            child: Text('取消', style: GoogleFonts.notoSansSc(),), 
            onPressed: () => Navigator.pop(context)
          ),
          FilledButton(
            child: Text('添加', style: GoogleFonts.notoSansSc(),), 
            onPressed: ()=>addHandler(context, manual)
          )
        ],
      )
    );
  }
}