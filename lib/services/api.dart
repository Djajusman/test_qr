import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

http.Client client = http.Client();
Future postAchievement(String data) async {
  try {
    Map body = {
      "jsonrpc": "2.0",
      "params": {"comment": data}
    };
    // var token = await getToken();

    Map<String, String> headers = {
      // 'Authorization': 'Bearer ${box.read("token")}',
      'Content-Type': "application/json",
      // 'X-Openerp': "${await getToken()}"
      'X-Openerp': "0ab74fb2f0474a39b772f4731fdaa540"
    };

    String uri = "http://156.67.219.148/create/daily_achievement";
    Uri url = Uri.parse(uri);
    print("INI HEADER");
    print(headers);
    print("INI BODY");
    print(body);
    print("INI URL");
    print(url.toString());
    http.Response response =
        await client.post(url, headers: headers, body: jsonEncode(body));
    // Get.snackbar(data, jsonDecode(response.body));
    // return response;
    // var dataResponse = jsonDecode(response.body);
    print("jsonDecode(response.body)");
    print(response.body);
    // print(dataResponse);
  } catch (e) {
    // Get.snackbar("Error", e.toString());
    print(e.toString());
    // rethrow;
  }
}

Future getToken() async {
  try {
    // http.Client client = http.Client();
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
    var data = jsonDecode(response.body);
    // Get.snackbar("Response", data["result"]["ocn_token_key"]);
    return data["result"]["ocn_token_key"];
  } catch (e) {
    Get.snackbar("Error", e.toString());
    print(e.toString());
    rethrow;
  }
}
