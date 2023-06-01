import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          backButton,
          Container(
              child: QrImageView(
            data: user!.toJson(user).toString(),
            version: QrVersions.auto,
            size: 200.0,
          )),
          const SizedBox(height: 10.0),
          Text(
            'Generated on $currentDate',
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    ));
  }
}
