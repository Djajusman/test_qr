import 'package:flutter/material.dart';
import 'package:odoo/odoo.dart';
import 'package:test_qr/services/api.dart';

import 'utils/qr_camera.dart';

final odoo = Odoo(Connection(
    url: Url(Protocol.http, "156.67.219.148", 8087), db: 'koinpack-2'));

void main() => runApp(const MaterialApp(home: MyHome()));

class MyHome extends StatelessWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('QR Scanner Home Page'),
          backgroundColor: Color.fromRGBO(101, 74, 94, 1)),
      // backgroundColor: Colors.deepPurple[500],
      // backgroundColor: Color.fromRGBO(101, 74, 94, 1),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // await postAchievement("data");
            // await getToken();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const QRViewExample(),
            ));
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromRGBO(101, 74, 94, 1)),
          ),
          child: const Text('Open QR Scanner'),
        ),
      ),
    );
  }
}
