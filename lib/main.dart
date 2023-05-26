import 'package:flutter/material.dart';
import 'package:otp_autofill_app/alt_sms_autofill.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: const AltSmsAutofillScreen(),
    );
  }
}
