import 'package:aria_ui/conponents/setting_item.dart';
import 'package:aria_ui/funcs/prefs.dart';
import 'package:aria_ui/funcs/services.dart';
import 'package:aria_ui/variables/page_var.dart';
import 'package:aria_ui/variables/setting_var.dart';
import 'package:aria_ui/variables/task_var.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  TextEditingController rpc=TextEditingController();
  TextEditingController secret=TextEditingController();
  final SettingVar s=Get.put(SettingVar());
  final PageVar p=Get.put(PageVar());

  void initRPC(){
    if(s.rpc.value.isNotEmpty){
      rpc.text=s.rpc.value;
    }
    if(s.secret.value.isNotEmpty){
      secret.text=s.secret.value;
    }
  }

  // 允许覆盖【allow-overwrite】
  bool overwrite=false;
  // 下载位置【dir】
  TextEditingController dir=TextEditingController();
  // 最多同时下载个数【max-concurrent-downloads】
  int maxDownloads=5;
  // 做种时间【seed-time】
  int seedTime=0;
  // 下载限制【max-overall-download-limit】
  int downloadLimit=0;
  // 上传限制【max-overall-upload-limit】
  int uploadLimit=0;
  // 用户代理【user-agent】
  TextEditingController userAgent=TextEditingController();
  // 做种比率【seed-ratio】
  double seedRatio=0.0;

  Future<void> initSettings() async {
    await Services().getGlobalSettings();
    setState(() {
      try {
        overwrite=s.settings['allow-overwrite']=='true';
      } catch (_) {
      }
      try {
        dir.text=s.settings['dir'];
      } catch (_) {}
      try {
        maxDownloads=int.parse(s.settings['max-concurrent-downloads']);
      } catch (_) {}
      try {
        seedTime=int.parse(s.settings['seed-time']);
      } catch (_) {}
      try {
        downloadLimit=int.parse(s.settings['max-overall-download-limit']);
      } catch (_) {}
      try {
        uploadLimit=int.parse(s.settings['max-overall-upload-limit']);
      } catch (_) {}
      try {
        userAgent.text=s.settings['user-agent'];
      } catch (_) {}
      try {
        seedRatio=s.settings['seed-ratio'];
      } catch (_) {}
    });
  }

  late Worker rpcListener;
  late Worker settingsListener;
  late Worker pageListener;

  @override
  void initState() {
    super.initState();
    pageListener=ever(p.nowPage, (val){
      if(val==Pages.settings){
        initRPC();
        initSettings();
      }
    });
  }

  @override
  void dispose() {
    rpcListener.dispose();
    settingsListener.dispose();
    pageListener.dispose();
    super.dispose();
  }

  TaskVar t=Get.put(TaskVar());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ListView(
            children: [
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text('程序设置', style: GoogleFonts.notoSansSc(
                  fontSize: 25
                ),),
              ),
              Obx(()=>
                Align(
                  alignment: Alignment.topCenter,
                  child: SettingItem(
                    label: '活跃任务排序方式',
                    item: Row(
                      children: [
                        ComboBox(
                          value: s.defaultActiveOrder.value,
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
                            if(val!=null){
                              s.defaultActiveOrder.value=val;
                              Prefs().saveAppPrefs();
                            }
                          },
                        ),
                      ],
                    )
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Obx(()=>
                Align(
                  alignment: Alignment.topCenter,
                  child: SettingItem(
                    label: '完成任务排序方式',
                    item: Row(
                      children: [
                        ComboBox(
                          value: s.defaultFinishedOrder.value,
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
                            if(val!=null){
                              s.defaultFinishedOrder.value=val;
                              Prefs().saveAppPrefs();
                            }
                          },
                        ),
                      ],
                    )
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              const Divider(),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text('Aria 设置', style: GoogleFonts.notoSansSc(
                  fontSize: 25
                ),),
              ),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.topCenter,
                child: SettingItem(
                  label: 'RPC地址', 
                  item: TextBox(
                    controller: rpc,
                    placeholder: 'http(s)://',
                    autocorrect: false,
                    enableSuggestions: false,
                    style: GoogleFonts.notoSansSc(),
                  )
                ),
              ),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.topCenter,
                child: SettingItem(
                  label: 'RPC密钥',
                  item: TextBox(
                    controller: secret,
                    autocorrect: false,
                    enableSuggestions: false,
                    obscureText: true,
                    style: GoogleFonts.notoSansSc(),
                  )
                ),
              ),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.topCenter,
                child: SettingItem(
                  label: '允许覆盖',
                  item: Row(
                    children: [
                      ToggleSwitch(
                        checked: overwrite, 
                        onChanged: (val){
                          setState(() {
                            overwrite=val;
                          });
                        }
                      ),
                    ],
                  )
                ),
              ),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.topCenter,
                child: SettingItem(
                  label: '下载位置',
                  item: TextBox(
                    controller: dir,
                    autocorrect: false,
                    enableSuggestions: false,
                    style: GoogleFonts.notoSansSc(),
                  )
                ),
              ),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.topCenter,
                child: SettingItem(
                  label: '最大同时下载个数',
                  item: NumberBox(
                    value: maxDownloads,
                    clearButton: false,
                    mode: SpinButtonPlacementMode.inline,
                    onChanged: (val){
                      if(val!=null){
                        setState(() {
                          maxDownloads=val;
                        });
                      }
                    }
                  )
                ),
              ),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.topCenter,
                child: SettingItem(
                  label: '做种时间',
                  item: NumberBox(
                    clearButton: false,
                    value: seedTime,
                    mode: SpinButtonPlacementMode.inline,
                    onChanged: (val){
                      if(val!=null){
                        setState(() {
                          seedTime=val;
                        });
                      }
                    }
                  )
                ),
              ),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.topCenter,
                child: SettingItem(
                  label: '做种比率',
                  item: NumberBox(
                    clearButton: false,
                    value: seedRatio,
                    mode: SpinButtonPlacementMode.inline,
                    onChanged: (val){
                      if(val!=null){
                        setState(() {
                          seedRatio=val;
                        });
                      }
                    }
                  )
                ),
              ),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.topCenter,
                child: SettingItem(
                  label: '下载速度限制',
                  item: NumberBox(
                    clearButton: false,
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
                ),
              ),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.topCenter,
                child: SettingItem(
                  label: '上传速度限制',
                  item: NumberBox(
                    clearButton: false,
                    value: uploadLimit,
                    mode: SpinButtonPlacementMode.inline,
                    onChanged: (val){
                      if(val!=null){
                        setState(() {
                          uploadLimit=val;
                        });
                      }
                    }
                  )
                ),
              ),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.topCenter,
                child: SettingItem(
                  label: '用户代理',
                  item: TextBox(
                    controller: userAgent,
                    autocorrect: false,
                    enableSuggestions: false,
                    style: GoogleFonts.notoSansSc(),
                    maxLines: 5,
                  )
                ),
              ),
              const SizedBox(height: 20,)
            ],
          ),
        ),
        const SizedBox(height: 10,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Button(
              child: Text('放弃保存', style: GoogleFonts.notoSansSc(),),
              onPressed: (){
                showDialog(
                  context: context, 
                  builder: (context)=>ContentDialog(
                    title: Text('放弃保存?', style: GoogleFonts.notoSansSc(),),
                    content: Text('这不会保留你的所有修改', style: GoogleFonts.notoSansSc(),),
                    actions: [
                      Button(
                        child: Text('取消', style: GoogleFonts.notoSansSc(),), 
                        onPressed: (){
                          Navigator.pop(context);
                        }
                      ),
                      FilledButton(
                        child: Text('放弃', style: GoogleFonts.notoSansSc(),),
                        onPressed: (){
                          rpc.text=s.rpc.value;
                          secret.text=s.secret.value;
                          Navigator.pop(context);
                        }
                      )
                    ],
                  )
                );
              }
            ),
            const SizedBox(width: 10,),
            FilledButton(
              child: Text('保存', style: GoogleFonts.notoSansSc(),), 
              onPressed: () async {
                FocusScope.of(context).unfocus();
                await Prefs().setPrefs(rpc.text, secret.text);
                await Services().savePrefs({
                  "allow-overwrite": overwrite.toString(),
                  "dir": dir.text,
                  "max-concurrent-downloads": maxDownloads.toString(),
                  "seed-time": seedTime.toString(),
                  "max-overall-download-limit": downloadLimit.toString(),
                  "max-overall-upload-limit": uploadLimit.toString(),
                  "user-agent": userAgent.text
                });
                if(context.mounted){
                  await displayInfoBar(
                    context, 
                    builder: (context, close) => InfoBar(
                      title: Text('保存设置成功', style: GoogleFonts.notoSansSc(),),
                      severity: InfoBarSeverity.success,
                    )
                  );
                }
                // Navigator.pop(context);
              }
            )
          ],
        ),
        const SizedBox(height: 30,)
      ],
    );
  }
}