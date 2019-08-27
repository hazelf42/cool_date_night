import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

final String testID = 'gems_test';

class MarketScreen extends StatefulWidget {
  createState() => MarketScreenState();
}

class MarketScreenState extends State<MarketScreen> {

  /// Is the API available on the device
  bool _available = true;

  /// The In App Purchase plugin
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

  /// Products for sale
  List<ProductDetails> _products = [];

  /// Past purchases
  List<PurchaseDetails> _purchases = [];

  /// Updates to purchases
  StreamSubscription _subscription;

  /// Consumable credits the user can buy
  int credits = 0;

  String iapID = 'android.tex';

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
    print(_iap);
    _available = await _iap.isAvailable();

    if (_available) {

      await _getProducts();
      await _getPastPurchases();

      // Verify and deliver a purchase with your own business logic
      _verifyPurchase();

    }
  }


  @override
  Widget build(BuildContext context) {
    _getProducts();
    return Scaffold(
      appBar: AppBar(
        title: Text(_available ? 'Open for Business' : 'Not Available'),
      ),
      body: Center(
        child: Text(_products.length > 0 ? [0].toString() : "Hi")
        ),
      );
  }
 

  /// Get all products available for sale
  Future<void> _getProducts() async {
    Set<String> ids = Set.from(['unlock_all']);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);

    setState(() { 
      _products = response.productDetails;
    });
  }

  /// Gets past purchases
  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response =
        await _iap.queryPastPurchases();

    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }

    setState(() {
      _purchases = response.pastPurchases;
    });
  }

  /// Returns purchase of specific product ID
  PurchaseDetails _hasPurchased(String productID) {
    return _purchases.firstWhere( (purchase) => purchase.productID == productID, orElse: () => null);
  }

  // / Your own business logic to setup a consumable
  void _verifyPurchase() {
    PurchaseDetails purchase = _hasPurchased(testID);

    // TODO serverside verification & record consumable in the database

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      
    }
  }
  // Private methods go here

}