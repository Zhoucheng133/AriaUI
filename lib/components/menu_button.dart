import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuButton extends StatefulWidget {

  final IconData icon;
  final String name;
  final VoidCallback func;
  final bool? enable;

  const MenuButton({super.key, required this.icon, required this.name, required this.func, this.enable});

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {

  bool hover=false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.func,
      child: MouseRegion(
        cursor: widget.enable==false ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        onEnter: (_){
          setState(() {
            hover=true;
          });
        },
        onExit: (_){
          setState(() {
            hover=false;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: widget.enable==false ? const Color.fromARGB(0, 234, 234, 234) : hover ? const Color.fromARGB(255, 234, 234, 234) : const Color.fromARGB(0, 234, 234, 234)
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 5),
            child: Row(
              children: [
                FaIcon(
                  widget.icon,
                  size: 14,
                  color: widget.enable==false ? Colors.grey[50]: Colors.black,
                ),
                const SizedBox(width: 5,),
                Text(
                  widget.name, 
                  style: GoogleFonts.notoSansSc(
                    color: widget.enable==false ? Colors.grey[50] : Colors.black,
                  ),
                )
              ],
            ),
          ), 
        ),
      ),
    );
  }
}