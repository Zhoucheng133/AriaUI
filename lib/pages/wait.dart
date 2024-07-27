import 'package:fluent_ui/fluent_ui.dart';

class WaitView extends StatefulWidget {
  const WaitView({super.key});

  @override
  State<WaitView> createState() => _WaitViewState();
}

class _WaitViewState extends State<WaitView> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('等待中'),
    );
  }
}