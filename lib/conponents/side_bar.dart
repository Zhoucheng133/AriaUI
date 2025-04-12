import 'package:aria_ui/conponents/side_bar_item.dart';
import 'package:aria_ui/variables/page_var.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {

  PageVar p=Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7, right: 10),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10,),
                const SideBarItem(name: Pages.fold, icon: FontAwesomeIcons.bars),
                const SizedBox(height: 5,),
                const SideBarItem(name: Pages.active, icon: FontAwesomeIcons.download),
                const SizedBox(height: 5,),
                const SideBarItem(name: Pages.finished, icon: FontAwesomeIcons.check),
                Expanded(child: Container()),
                const SideBarItem(name: Pages.about, icon: FluentIcons.info_solid),
                const SizedBox(height: 5,),
                const SideBarItem(name: Pages.settings, icon: FontAwesomeIcons.gear),
                const SizedBox(height: 20,),
              ],
            ),
          ),
          Expanded(child: Container())
        ],
      ),
    );
  }
}