import 'package:flutter/material.dart';
import 'package:flutter_pay/flutter_pay.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_clean/widgets/dialogs.dart';

class MarketScreen extends StatefulWidget {
  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {

  googlePay()async{
    try{
      FlutterPay flutterPay = FlutterPay();
      if(!await flutterPay.canMakePayments()) return Fluttertoast.showToast(msg: 'Cannnot make payments');
      if(! await flutterPay.canMakePaymentsWithActiveCard(allowedPaymentNetworks: [
        PaymentNetwork.visa,PaymentNetwork.masterCard
      ])) return Fluttertoast.showToast(msg: 'No active card');
      PaymentItem item = PaymentItem(name: "token", price: 1);
      flutterPay.setEnvironment(environment: PaymentEnvironment.Test);
      String token = await flutterPay.requestPayment(
      googleParameters: GoogleParameters(
        gatewayName: "Stripe",
        gatewayMerchantId: "Songskyltd@gmail.com",
		merchantId: "Songskyltd@gmail.com",
		merchantName: "songsky",
      ),
      appleParameters:
          AppleParameters(merchantIdentifier: "Songskyltd@gmail.com "),
      currencyCode: "CA",
      countryCode: "CAD",
      paymentItems: [item],
    );
    print(token);
    }
    catch(e){
      customErrorDialog(context, 'Google Pay error', e.toString());
    }
  }

  @override
  void initState() {
    googlePay();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }
}