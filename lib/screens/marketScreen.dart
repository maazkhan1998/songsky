import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_clean/provider/authentication_service.dart';
import 'package:new_clean/widgets/dialogs.dart';
import 'package:new_clean/widgets/emailNameTextField.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class MarketScreen extends StatefulWidget {
  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {

  TextEditingController controller=TextEditingController();

 Pay _payClient = Pay.withAssets([
  'gPay.json'
]);

bool isNumeric(String s) {

 return int.tryParse(s) != null;
}


 onGooglePayPressed() async {
  if(!isNumeric(controller.text)) return Fluttertoast.showToast(msg: 'Invalid input');
  if(int.parse(controller.text)<100) return Fluttertoast.showToast(msg: 'Minimum limit is 100 coins');
  final result = await _payClient.showPaymentSelector(
    provider: PayProvider.google_pay,
    paymentItems: [
      PaymentItem(amount: '${int.parse(controller.text)*0.11}',label: '${controller.text} Tokens',status: PaymentItemStatus.final_price)
    ],
  );
  try{
  if(result!=null){
    progressIndicator(context);
    final data=result['paymentMethodData']['tokenizationData']['token'];
    final String token=json.decode(data)['id'];
    print(token);
    await Provider.of<AuthenticationService>(context,listen:false).stripAPI(controller.text, token);
    Navigator.of(context,rootNavigator: true).pop();
  }
   }
   catch(e){
     Navigator.of(context,rootNavigator: true).pop();
     customErrorDialog(context,'Something went wrong',e.toString());
   }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal:20),
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EmailNameTextField(text: 'Coins', controller: controller, type: TextInputType.number, icon: Icon(FontAwesomeIcons.coins)),
              SizedBox(height: ScreenUtil().setHeight(10)),
              Text('1 coin=0.011 CAD')
            ],
          ),
        ),
      ),
      floatingActionButton: FutureBuilder<bool>(
    future: _payClient.userCanPay(PayProvider.google_pay),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.data == true) {
          return RawGooglePayButton(
            style: GooglePayButtonStyle.black,
            type: GooglePayButtonType.pay,
            onPressed: onGooglePayPressed);
        } else {
          return Center(child: Text('Payment options unavailable'));
        }
      }
      return Center(child: CircularProgressIndicator(),);
    },
  ),
    );
  }
}