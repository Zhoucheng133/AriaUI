import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AddButton extends StatefulWidget {
  const AddButton({super.key});

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {

  bool hover=false;
  final menuController = FlyoutController();

  @override
  Widget build(BuildContext context) {
    return FlyoutTarget(
      controller: menuController,
      child: GestureDetector(
        onTap: (){
          menuController.showFlyout(
            autoModeConfiguration: FlyoutAutoConfiguration(
              preferredMode: FlyoutPlacementMode.bottomLeft,
            ),
            barrierDismissible: true,
            dismissOnPointerMoveAway: false,
            builder: (context)=>MenuFlyout(
              shadowColor: Colors.transparent,
              items: [
                MenuFlyoutItem(
                  leading: const Icon(FontAwesomeIcons.plus),
                  text: Text('添加磁力链接', style: GoogleFonts.notoSansSc(),),
                  onPressed: (){
                    // TODO 添加磁力链接
                    Flyout.of(context).close();
                  },
                ),
                MenuFlyoutItem(
                  leading: const Icon(FontAwesomeIcons.plus),
                  text: Text('添加Torrent', style: GoogleFonts.notoSansSc(),),
                  onPressed: (){
                    // TODO 添加Torrent
                    Flyout.of(context).close();
                  },
                ),
              ],
            )
          );
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
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
              color: hover ? const Color.fromARGB(255, 234, 234, 234) : const Color.fromARGB(0, 234, 234, 234)
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 5),
              child: Row(
                children: [
                  FaIcon(
                    // MenuButton(icon: FontAwesomeIcons.plus, name: '添加', func: ()=>AddTask().addTask(context, setState)),
                    FontAwesomeIcons.plus,
                    size: 14,
                    color: Colors.black,
                  ),
                  SizedBox(width: 5,),
                  Text(
                    "添加", 
                  )
                ],
              ),
            ), 
          ),
        ),
      ),
    );
  }
}

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
      onTap: (){
        if(widget.enable!=false){
          widget.func();
        }
      },
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