import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

final String testID = 'gems_test';

class MarketScreen extends StatefulWidget {
  final String uid;
  MarketScreen(this.uid);
  _MarketScreen createState() => _MarketScreen(this.uid);
}

class _MarketScreen extends State<MarketScreen> {
  final String uid;
  _MarketScreen(this.uid);

  /// Is the API available on the device
  bool available = true;

  /// The In App Purchase plugin
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;

  /// Past purchases
  List<PurchaseDetails> _purchases = [];

  /// Updates to purchases
  StreamSubscription _subscription;

  /// Consumable credits the user can buy
  int credits = 0;

  @override
  void initState() {
    _verifyPurchase();
    _subscription = _iap.purchaseUpdatedStream.listen((data) => setState(() {
          print('NEW PURCHASE');
          print(data);
          _purchases.addAll(data);
          _verifyPurchase();
        }));
    super.initState();  
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.Colors.midnightBlue,
      ),
      backgroundColor: Theme.Colors.midnightBlue,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100),
            // UI if already purchased
            // (_hasPurchased("unlock_all") != null)
            // ? _purchaseComplete(context: context)
            // :
            _notPaidUI(uid, context)
          ],
        ),
      ),
    );
  }

  // Private methods go here

  Future<Widget> _purchaseComplete({@required BuildContext context}) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.Colors.midnightBlue,
            actions: <Widget>[
              FlatButton(
                child: Text("LET'S GO!",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                color: Colors.white.withOpacity(.30),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              )
            ],
            title: Text("Welcome to Cool Date Night!",
                style: TextStyle(color: Colors.white)),
            content: Text(
                "You've unlocked all our cool dates. Grab your date mate and let's get started!",
                style: TextStyle(color: Colors.white)),
          );
        });
  }

  Widget _notPaidUI(String uid, BuildContext context) {
    var _iap = InAppPurchaseConnection.instance;
    return Column(
      children: <Widget>[
        SizedBox(height: 50),
        Center(
            child: IconButton(
                icon: Icon(Icons.lock_open, color: Theme.Colors.mustard),
                iconSize: MediaQuery.of(context).size.width / 3,
                onPressed: () {
                  // _getPastPurchases().then((_) {
                  _iap
                      .queryProductDetails(Set.from(["unlock_all"]))
                      .then((prodDetails) async {
                    _buyProduct(prodDetails.productDetails[0]);
                  });
                  // });
                })),
        RaisedButton(
            elevation: 7.5,
            color: Theme.Colors.mustard,
            child: Text("Unlock all cool dates"),
            onPressed: () {
              _iap
                  .queryProductDetails(Set.from(["unlock_all"]))
                  .then((prodDetails) {
                _buyProduct(prodDetails.productDetails[0]);
              });
            })
      ],
    );
  }

//broken, i didnt even write this code
  // Future<void> _getPastPurchases() async {
  //   print("Querying past purchases");
  //   QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();

  //   for (PurchaseDetails purchase in response.pastPurchases) {
  //   }
  //   print(response.pastPurchases);
  //   setState(() {
  //     _purchases = response.pastPurchases;
  //   });
  // }

  /// Returns purchase of specific product ID
  PurchaseDetails _hasPurchased(String productID) {
    var returner = _purchases.firstWhere(
        (purchase) => purchase.productID == productID,
        orElse: () => null);
    print(returner);
    return returner;
  }

  /// Your own business logic to setup a consumable
  void _verifyPurchase() async {
    PurchaseDetails purchase = _hasPurchased("unlock_all");
    print("Verifying...");
    print(purchase.status);
    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      Firestore.instance
          .collection("users")
          .document(uid)
          .updateData({"isPaid": true}).then((_) async {
        await _purchaseComplete(context: context);
      });
    }
  }

  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyNonConsumable(purchaseParam: purchaseParam).then((_) {});
  }
}
