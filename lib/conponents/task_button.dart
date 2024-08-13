import 'package:fluent_ui/fluent_ui.dart';

class TaskButton extends StatefulWidget {

  final String gid;
  final VoidCallback func;
  final IconData icon;
  final String hint;
  final bool enabled;

  const TaskButton({super.key, required this.gid, required this.func, required this.icon, required this.hint, required this.enabled});

  @override
  State<TaskButton> createState() => _TaskButtonState();
}

class _TaskButtonState extends State<TaskButton> {

  bool hover=false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.enabled){
          widget.func();
        }
      },
      child: MouseRegion(
        cursor: widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
        onEnter: (_){
          if(widget.enabled){
            setState(() {
              hover=true;
            });
          }
        },
        onExit: (_){
          if(widget.enabled){
            setState(() {
              hover=false;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: widget.enabled==false ? const Color.fromARGB(0, 234, 234, 234) : hover? const Color.fromARGB(255, 234, 234, 234) : const Color.fromARGB(0, 234, 234, 234)
          ),
          child: Center(
            child: Icon(
              widget.icon,
              size: 14,
            ),
          ),
        ),
      ),
    );
  }
}