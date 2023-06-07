import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_app/models/log_model.dart';
import 'package:project_app/models/user_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

//pass
class QRCodeGenerator extends StatelessWidget {
  UserModel user;

  QRCodeGenerator({required this.user});

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final backButton = IconButton(
      onPressed: () async {
        Navigator.pop(context);
      },
      icon: const Icon(
        Icons.arrow_back_rounded,
        color: Color(0xFFA095C1),
      ),
    );

    // String jsonString = '{"uid": "${user.id}", "date": "${currentDate}"}';

    // Map<String, dynamic> data = {"uid": user.uid, "date": currentDate};

    Log log = Log();
    log.uid = user.id;
    log.date = currentDate;
    log.name = user.name;
    log.stdnum = user.stdnum;
    final data = log.toJson(log);
    const JsonEncoder encoder = JsonEncoder.withIndent(' ');
    String newJSON = encoder.convert(data);

    Map<String, dynamic> map = jsonDecode(newJSON);

    print(data);
    print(newJSON);
    print(map);
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          backButton,
          Container(
              child: QrImageView(
            data: newJSON,
            version: QrVersions.auto,
            size: 200.0,
          )),
          const SizedBox(height: 10.0),
          Text(
            'Generated on $currentDate',
            style: const TextStyle(fontFamily: 'Raleway', fontSize: 16.0),
          ),
        ],
      ),
    ));
  }
}
