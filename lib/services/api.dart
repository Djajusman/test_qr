import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future postAchievement(String data) async {
  http.Client client = http.Client();
  try {
    Map body = {
      "jsonrpc": "2.0",
      "params": {"comment": data}
    };
    Map<String, String> headers = {
      // 'Authorization': 'Bearer ${box.read("token")}',
      'Content-Type': "application/json",
      'X-Openerp': await getToken()
    };
    String uri = "http://156.67.219.148/create/daily_achievement";
    Uri url = Uri.parse(uri);
    http.Response response =
        await client.post(url, headers: headers, body: jsonEncode(body));
    return response;
  } catch (e) {
    // Get.snackbar("Error", e.toString());
    debugPrint(e.toString());
    rethrow;
  }
}

Future getToken() async {
  try {
    http.Client client = http.Client();
    Map body = {
      "jsonrpc": "2.0",
      "params": {
        "db": "test_dev",
        "login": "tsaniyadiriyadh@gmail.com",
        "password": "admin!"
      }
    };
    Map<String, String> headers = {
      'Content-Type': "application/json",
    };
    String uri = "http://156.67.219.148/web/session/authenticate";
    Uri url = Uri.parse(uri);
    http.Response response =
        await client.post(url, headers: headers, body: jsonEncode(body));
    return jsonDecode(response.body)["result"]["ocn_token_key"];
  } catch (e) {
    // Get.snackbar("Error", e.toString());
    debugPrint(e.toString());
    rethrow;
  }
}
