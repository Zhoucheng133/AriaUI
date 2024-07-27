import 'dart:async';
import 'dart:convert';
import 'package:aria_ui/variables/setting_var.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Requests{

  final SettingVar s=Get.put(SettingVar());

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

  Future<List> getActive() async {
    try {
      return (await httpRequest({
        "jsonrpc":"2.0",
        "method":"aria2.tellActive",
        "id":"ariaui",
        "params":["token:${s.secret.value}"]
      }))['result'];
    } catch (_) {
      return [];
    }
  }

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
}