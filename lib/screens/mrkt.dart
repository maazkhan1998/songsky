import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:async/async.dart';

final String testID = 'sky_coins';

class MarketScreen extends StatefulWidget {
  createState() => MarketScreenState();
}

class MarketScreenState extends State<MarketScreen> {
  /// Is the API available on the device
  bool available = true;

  /// The In App Purchase plugin
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

  /// Products for sale
  List<ProductDetails> _products = [];

  /// Past purchases
  List<PurchaseDetails> _purchases = [];

  /// Updates to purchases
  late StreamSubscription _subscription;

  /// Consumable credits the user can buy
  int credits = 0;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  /// Initialize data
  void _initialize() async {
    // Check availability of In App Purchases
    available = await _iap.isAvailable();

    if (available) {
      await _getProducts();
      await _getPastPurchases();

      // Verify and deliver a purchase with your own business logic
      _verifyPurchase();
    }
    // Listen to new purchases
    _subscription = _iap.purchaseUpdatedStream.listen((data) => setState(() {
          print('NEW PURCHASE');
          _purchases.addAll(data);
          _verifyPurchase();
        }));
  }

  /// Get all products available for sale
  Future<void> _getProducts() async {
    Set<String> ids = Set.from([testID, 'test_a']);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    setState(() {
      _products = response.productDetails;
    });
  }

  /// Gets past purchases
  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

    setState(() {
      _purchases = response.pastPurchases;
    });
  }

  /// Returns purchase of specific product ID
  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere((purchase) => purchase.productID == productID,);
  }

  /// Your own business logic to setup a consumable
  void _verifyPurchase() {
    PurchaseDetails purchase = _hasPurchased(testID);

    // TODO serverside verification & record consumable in the database

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      credits = 10;
    }
  }

  /// Purchase a product
  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    // _iap.buyNonConsumable(purchaseParam: purchaseParam);
    _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: false);
  }

  /// Spend credits and consume purchase when they run pit
  void _spendCredits(PurchaseDetails purchase) async {
    /// Decrement credits
    setState(() {
      credits--;
    });

    /// TODO update the state of the consumable to a backend database

    // Mark consumed when credits run out
    if (credits == 0) {
      var res = await _iap.consumePurchase(purchase);
      await _getPastPurchases();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(available ? "Buy SkyCoins" : "Not available"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var prod in _products)
              if (_hasPurchased(prod.id) != null) ...[
                Text("$credits SkyCoins", style: TextStyle(fontSize: 60)),
                FlatButton(
                    onPressed: () => _spendCredits(_hasPurchased(prod.id)),
                    child: Text("Consume"))
              ] else ...[
                Text(prod.title, style: Theme.of(context).textTheme.headline5),
                Text(prod.description),
                Text(prod.price,
                    style: TextStyle(color: Colors.greenAccent, fontSize: 60)),
                FlatButton(
                  onPressed: () => _buyProduct(prod),
                  child: Text("Buy"),
                  color: Colors.green,
                ),
              ]
          ],
        ),
      ),
    );
  }
}
