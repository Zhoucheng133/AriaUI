
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:aria_ui/conponents/menu_button.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Downloading extends StatefulWidget {
  const Downloading({super.key});

  @override
  State<Downloading> createState() => _DownloadingState();
}

class _DownloadingState extends State<Downloading> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        children: [
          Row(
            children: [
              MenuButton(icon: FontAwesomeIcons.plus, name: '添加', func: (){}),
              SizedBox(width: 10,),
              MenuButton(icon: FontAwesomeIcons.squareCheck, name: '选择', func: (){}),
              SizedBox(width: 10,),
              MenuButton(icon: FontAwesomeIcons.list, name: '全选', func: (){}),
              SizedBox(width: 10,),
              MenuButton(icon: FontAwesomeIcons.play, name: '继续', func: (){}, enable: false,),
              SizedBox(width: 10,),
              MenuButton(icon: FontAwesomeIcons.pause, name: '暂停', func: (){}, enable: false,),
              SizedBox(width: 10,),
              MenuButton(icon: FontAwesomeIcons.trash, name: '移除', func: (){}, enable: false,),
            ],
          ),
          const SizedBox(height: 5,),
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 234, 234, 234),
              borderRadius: BorderRadius.circular(2),
            ),
          )
        ],
      ),
    );
  }
}