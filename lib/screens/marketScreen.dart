import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_clean/widgets/emailNameTextField.dart';
import 'package:pay/pay.dart';

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

 return double.tryParse(s) != null;
}


 onGooglePayPressed() async {
  if(!isNumeric(controller.text)) return Fluttertoast.showToast(msg: 'Invalid input');
  if(double.parse(controller.text)<1203) return Fluttertoast.showToast(msg: 'Minimum limit is 1203 coins');
  final result = await _payClient.showPaymentSelector(
    provider: PayProvider.google_pay,
    paymentItems: [],
  );
  // Send the resulting Google Pay token to your server / PSP
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
              Text('1 coin=0.01 CAD')
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