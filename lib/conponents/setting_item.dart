import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingItem extends StatefulWidget {

  final String label;
  final Widget item;

  const SettingItem({super.key, required this.label, required this.item});

  @override
  State<SettingItem> createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 120,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              widget.label,
              style: GoogleFonts.notoSansSc(),
            ),
          ),
        ),
        const SizedBox(width: 10,),
        SizedBox(
          width: 270,
          child: widget.item,
        )
      ],
    );
  }
}