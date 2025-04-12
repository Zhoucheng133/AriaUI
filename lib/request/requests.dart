import 'dart:async';
import 'dart:convert';
import 'package:aria_ui/variables/setting_var.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Requests{

  final SettingVar s=Get.find();

  Future<Map> httpRequest(Map data) async {
    final url = Uri.parse(s.rpc.value);
    final body = json.encode(data);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      return {};
    }
  }

  // 获取活跃的任务
  Future<List?> tellActive() async {
    try {
      return (await httpRequest({
        "jsonrpc":"2.0",
        "method":"aria2.tellActive",
        "id":"ariaui",
        "params":["token:${s.secret.value}"]
      }))['result'];
    } catch (_) {
      return null;
    }
  }

  // 获取等待中的任务
  Future<List?> tellWaiting() async {
    try {
      return (await httpRequest({
        "jsonrpc":"2.0",
        "method":"aria2.tellWaiting",
        "id":"ariaui",
        "params":["token:${s.secret.value}", 0, 1000]
      }))['result'];
    } catch (_) {
      return null;
    }
  }
  
  // 获取已停止（完成）的任务
  Future<List?> tellStopped() async {
    try {
      return (await httpRequest({
        "jsonrpc":"2.0",
        "method":"aria2.tellStopped",
        "id":"ariaui",
        "params":["token:${s.secret.value}", 0, 1000]
      }))['result'];
    } catch (_) {
      return null;
    }
  }

  // 获取版本
  Future<String?> getVersion() async {
    try {
      return (await httpRequest({
        "jsonrpc":"2.0",
        "method":"aria2.getVersion",
        "id":"ariaui",
        "params":["token:${s.secret.value}"]
      }))['result']['version'];
    } catch (_) {
      return null;
    }
  }

  // 添加手动任务
  Future<void> addManualTask(List<String> urls, String path, String agent, int limit) async {
    for (var url in urls) {
      try {
        await httpRequest({
          "jsonrpc":"2.0",
          "method":"aria2.addUri",
          "id":"ariaui",
          "params":["token:${s.secret.value}", [url], {
            "user-agent": agent,
            "max-overall-download-limit": limit,
            "dir": path,
          }]
        });
      } catch (_) {}
    }
  }

  // 添加任务
  Future<void> addTask(List<String> urls) async {
    for (var url in urls) {
      try {
        await httpRequest({
          "jsonrpc":"2.0",
          "method":"aria2.addUri",
          "id":"ariaui",
          "params":["token:${s.secret.value}", [url], {}]
        });
      } catch (_) {}
    }
  }

  // 移除任务
  Future<void> removeTask(String gid) async {
    try {
      await httpRequest({
        "jsonrpc":"2.0",
        "method":"aria2.remove",
        "id":"ariaui",
        "params":["token:${s.secret.value}", gid]
      });
    } catch (_) {}
  }

  // 移除任务（已完成的）
  Future<String?> removeFinishedTask(String gid) async {
    try {
      return (await httpRequest({
        "jsonrpc":"2.0",
        "method":"aria2.removeDownloadResult",
        "id":"ariaui",
        "params":["token:${s.secret.value}", gid]
      }))['result'];
    } catch (_) {
      return null;
    }
  }

  // 暂停任务
  Future<String?> pauseTask(String gid) async {
    try {
      return (await httpRequest({
        "jsonrpc":"2.0",
        "method":"aria2.pause",
        "id":"ariaui",
        "params":["token:${s.secret.value}", gid]
      }))['result'];
    } catch (_) {
      return null;
    }
  }

  // 继续任务
  Future<String?> continueTask(String gid) async {
    try {
      return (await httpRequest({
        "jsonrpc":"2.0",
        "method":"aria2.unpause",
        "id":"ariaui",
        "params":["token:${s.secret.value}", gid]
      }))['result'];
    } catch (_) {
      return null;
    }
  }

  // 清除所有已完成的任务
  Future<String?> clearFinished() async {
    try {
      return (await httpRequest({
        "jsonrpc":"2.0",
        "method":"aria2.purgeDownloadResult",
        "id":"ariaui",
        "params":["token:${s.secret.value}"]
      }))['result'];
    } catch (_) {
      return null;
    }
  }

  Future<String?> continueAll() async {
    try {
      return (await httpRequest({
        "jsonrpc":"2.0",
        "method":"aria2.unpauseAll",
        "id":"ariaui",
        "params":["token:${s.secret.value}"]
      }))['result'];
    } catch (_) {
      return null;
    }
  }

  Future<String?> pauseAll() async {
    try {
      return (await httpRequest({
        "jsonrpc":"2.0",
        "method":"aria2.pauseAll",
        "id":"ariaui",
        "params":["token:${s.secret.value}"]
      }))['result'];
    } catch (_) {
      return null;
    }
  }

  Future<Map?> getGlobalSettings() async {
    try {
      return (await httpRequest({
        "jsonrpc":"2.0",
        "method":"aria2.getGlobalOption",
        "id":"ariaui",
        "params":["token:${s.secret.value}"]
      }))['result'];
    } catch (_) {
      return null;
    }
  }

  Future<String?> changeGlobalSettings(Map settings) async{
    try {
      var resp=(await httpRequest({
        "jsonrpc":"2.0",
        "method":"aria2.changeGlobalOption",
        "id":"ariaui",
        "params":["token:${s.secret.value}", settings]
      }))['result'];
      return resp;
    } catch (_) {
      return null;
    }
  }
}