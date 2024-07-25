
import 'package:fluent_ui/fluent_ui.dart';

class DownloadingView extends StatefulWidget {
  const DownloadingView({super.key});

  @override
  State<DownloadingView> createState() => _DownloadingViewState();
}

class _DownloadingViewState extends State<DownloadingView> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('下载中'),
    );
  }
}