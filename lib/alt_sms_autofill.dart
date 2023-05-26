import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AltSmsAutofillScreen extends StatefulWidget {
  const AltSmsAutofillScreen({super.key});

  @override
  State<AltSmsAutofillScreen> createState() => _AltSmsAutofillScreenState();
}

class _AltSmsAutofillScreenState extends State<AltSmsAutofillScreen> {
  final TextEditingController otpController = TextEditingController();

  String receivedOTP = '';
  Future<void> listenForSms() async {
    String? incomingSms;
    try {
      incomingSms = (await AltSmsAutofill().listenForSms);
      if (incomingSms != null &&
          incomingSms.contains('iOS') == false &&
          // Replace 'Custom ApName' with a custom string unique to your message
          incomingSms.toLowerCase().contains('Custom App Name'.toLowerCase()) ==
              true) {
        // Count the index of your OTP and modify this line below
        receivedOTP = incomingSms.substring(26).trim();
        print("OTP received is: $receivedOTP");
        otpController.text = receivedOTP.trim();
        setState(() {});
        await Future.delayed(const Duration(milliseconds: 200)).then((value) {
          if (receivedOTP.trim().length == 5) {
            print('OTP is useful');
          } else {
            print('OTP is useless');
            setState(() {
              otpController.text = '';
            });
          }
        });
      }
    } on PlatformException {
      incomingSms = 'Failed to get Sms.';
    }
  }

  @override
  void initState() {
    super.initState();
    listenForSms();
  }

  @override
  void dispose() {
    otpController.dispose();
    AltSmsAutofill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AltAutoFill example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: 280,
                child: PinCodeTextField(
                  length: 5,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeColor: Colors.green,
                    activeFillColor: Colors.transparent,
                    selectedColor: Colors.amber,
                    selectedFillColor: Colors.transparent,
                    inactiveColor: Colors.grey,
                    inactiveFillColor: Colors.transparent,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  controller: otpController,
                  onCompleted: (cc) {
                    print("Completed");
                  },
                  onChanged: (value) {
                    print(value);
                    setState(() {});
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    return false;
                  },
                  appContext: context,
                ),
              ),
            ),
            TextButton(
              onPressed: listenForSms,
              child: const Text('Listen for sms code'),
            ),
          ],
        ),
      ),
    );
  }

  showMsgDialog(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Text(
              'Msg received is: $msg',
              style: const TextStyle(
                color: Colors.green,
              ),
            ),
          ),
        );
      },
    );
  }
}
