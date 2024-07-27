
import 'package:fluent_ui/fluent_ui.dart';

class FinishedView extends StatefulWidget {
  const FinishedView({super.key});

  @override
  State<FinishedView> createState() => _FinishedViewState();
}

class _FinishedViewState extends State<FinishedView> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('已完成'),
    );
  }
}