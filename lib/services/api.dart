import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

http.Client client = http.Client();
Future<String> postAchievement(String data) async {
  try {
    Map body = {
      "jsonrpc": "2.0",
      "params": {"comment": data}
    };

    Map<String, String> headers = {
      // 'Authorization': 'Bearer ${box.read("token")}',
      'Content-Type': "application/json",
      // "Cookie":
      //     "access_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOjcyLCJpYXQiOjE2ODQwOTE0NDgsIm5iZiI6MTY4NDA5MTQ0OCwianRpIjoiMTQwNzQzNWUtMGEwZC00MjQ2LWJjYmEtZjE0M2Y3ZmNiOTgwIiwiZXhwIjoxNjg0MDk4NjQ4LCJ0eXBlIjoiYWNjZXNzIiwiZnJlc2giOmZhbHNlfQ.EXK9yrcSy-oW4YK2Jn6aMrlWW2zSPMaZRp5sLCZkLYLDMs-ORWOOMv8Etu6FFOh23QAEGk44lsogJ7qMYOV2ebq1ustFnsZ5Q-tXPsN4OdcR2qdM3TBVcLIJ6DrexB2KqstWzQY4ZV3mEe8l5Hu5v7hNu7NpVGkTH0Z0Q-fVVck; logged_in=True; refresh_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOjcyLCJpYXQiOjE2ODQwOTE0NDgsIm5iZiI6MTY4NDA5MTQ0OCwianRpIjoiOGI1OGFjYTgtYzMzMS00ZTIyLTk0YTYtZjBmYTQ1MjM2MWQ2IiwiZXhwIjoxNjg0NjkxNDQ4LCJ0eXBlIjoicmVmcmVzaCJ9.PJJW1VvGo5DSBj4_tcu1kFV1L3Luwiul_sfxATNkdOa2ZuQF2itB4Lp0qrs-Epj-olygtqhKZ4gvpCD8ggO7W6hk0oE6hlrlWfj1YQr5yNa04BDc7wPXbMtfdKta2AXnm7xeuEjYHLzZmwqkFM7-snRSmIQfYdV5XuVc2glz6F4; session_id=af95e505ecf0a2654f335ae2f09128207ee7d764"
      // 'X-Openerp': "${await getToken()}"
      "Cookie": await getToken()
      // 'X-Openerp': "0ab74fb2f0474a39b772f4731fdaa540"
    };

    String uri = "http://156.67.219.148/create/daily_achievement";
    // String uri = "http://192.168.176.77:8087/create/daily_achievement";
    Uri url = Uri.parse(uri);
    // print("INI HEADER");
    // print(headers);
    // print("INI BODY");
    // print(body);
    // print("INI URL");
    // print(url.toString());
    http.Response response =
        await client.post(url, headers: headers, body: jsonEncode(body));
    // Get.snackbar(data, jsonDecode(response.body));
    // return response;
    // var dataResponse = jsonDecode(response.body);
    print("jsonDecode(response.body)");
    print(response.body);
    // print(dataResponse);
    return "Add Data $data Success";
    // Get.snackbar("Add Data Success", "$data has been addded");
  } catch (e) {
    // Get.snackbar("Error", e.toString());
    print(e.toString());
    return "Error: $e";
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
    // Map body = {
    //   "jsonrpc": "2.0",
    //   "params": {
    //     "db": "koinpack-2",
    //     "login": "ridwan@enviu.org",
    //     "password": "Pl@stics123"
    //   }
    // };
    Map<String, String> headers = {
      'Content-Type': "application/json",
    };
    String uri = "http://156.67.219.148/web/session/authenticate";
    // String uri = "http://192.168.176.77:8087/web/session/authenticate";
    Uri url = Uri.parse(uri);
    http.Response response =
        await client.post(url, headers: headers, body: jsonEncode(body));
    var data = jsonDecode(response.body);
    // Get.snackbar("Response", data["result"]["ocn_token_key"]);
    // print(response.body);
    // print(response.headers);
    return response.headers["set-cookie"];
  } catch (e) {
    Get.snackbar("Error", e.toString());
    print(e.toString());
    rethrow;
  }
}
