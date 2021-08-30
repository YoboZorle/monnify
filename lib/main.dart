import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:monnify_flutter_sdk/monnify_flutter_sdk.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late BuildContext mContext;

  @override
  void initState() {
    super.initState();
    initializeSdk();
  }

  Future<void> initializeSdk() async {
    try {
      if (await MonnifyFlutterSdk.initialize(
          'MK_TEST_G9YG93QQJA', '4551641593', ApplicationMode.TEST)) {
        _showToast("SDK initialized!");
      }
    } on PlatformException catch (e, s) {
      print("Error initializing sdk");
      print(e);
      print(s);

      _showToast("Failed to init sdk!");
    }
  }

  Future<void> initPayment() async {
    TransactionResponse transactionResponse;

    try {
      transactionResponse =
      await MonnifyFlutterSdk.initializePayment(Transaction(
        2000.0,
        "NGN",
        "Customer Name",
        "mail.cus@tome.er",
        getRandomString(15),
        "Description of payment",
        metaData: {
          "ip": "196.168.45.22",
          "device": "mobile"
        },
        paymentMethods: [PaymentMethod.CARD, PaymentMethod.ACCOUNT_TRANSFER],
        /*incomeSplitConfig: [SubAccountDetails("MFY_SUB_319452883968", 10.5, 500, true),
                SubAccountDetails("MFY_SUB_259811283666", 10.5, 1000, false)]*/
      ));

      _showToast(
          transactionResponse.transactionStatus.toString() + "\n" +
              transactionResponse.paymentReference.toString() + "\n" +
              transactionResponse.transactionReference.toString() + "\n" +
              transactionResponse.amountPaid.toString() + "\n" +
              transactionResponse.amountPayable.toString() + "\n" +
              transactionResponse.paymentDate.toString() + "\n" +
              transactionResponse.paymentMethod.toString());

    } on PlatformException catch (e, s) {
      print("Error initializing payment");
      print(e);
      print(s);

      _showToast("Failed to init payment!");
    }
  }

  String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  void _showToast(String message) {
    final scaffold = ScaffoldMessenger.of(mContext);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'CLOSE', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Monnify Plugin Sample'),
        ),
        body: Builder(
          builder: (context) {
            mContext = context;
            return Center(
              child: TextButton(
                child: Text("PAY"),
                onPressed: () => initPayment(),
              ),
            );
          },
        ),
      ),
    );
  }
}