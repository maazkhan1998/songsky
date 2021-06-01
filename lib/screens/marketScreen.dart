import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

class MarketScreen extends StatefulWidget {
  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GooglePayButton(
  paymentConfigurationAsset: 'gPay.json',
  paymentItems: [
    PaymentItem(amount: '10',label: 'Tokens',status: PaymentItemStatus.final_price)
  ],
  style: GooglePayButtonStyle.black,
  type: GooglePayButtonType.pay,
  margin: const EdgeInsets.only(top: 15.0),
  onPaymentResult: (data){
    print(data);
  },
  width: 200,
  height: 50,
  loadingIndicator: const Center(
    child: CircularProgressIndicator(),
  ),
),
      ),
    );
  }
}