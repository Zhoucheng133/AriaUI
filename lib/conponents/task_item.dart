// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TaskItem extends StatefulWidget {

  final String name;
  final int totalLength;
  final int completedLength; 
  final String dir;

  const TaskItem({super.key, required this.name, required this.totalLength, required this.completedLength, required this.dir});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(widget.name)
        ),
        SizedBox(height: 10,),
        Text('${widget.completedLength.toString()}/${widget.totalLength.toString()}'),
      ],
    );
  }
}