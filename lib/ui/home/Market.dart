import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_date_night/Theme.dart' as Theme;
import 'package:cool_date_night/helpers/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

//TODO: Validate
class MarketScreen extends StatefulWidget {
  final String uid;
  MarketScreen(this.uid);
  _MarketScreen createState() => _MarketScreen(this.uid);
}

class _MarketScreen extends State<MarketScreen> {
  final String uid;
  _MarketScreen(this.uid);
  FlutterInappPurchase _iap = FlutterInappPurchase.instance;
  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  String _platformVersion = 'Unknown';
  List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];


  @override
  void initState() {
    initPlatformState();

    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await FlutterInappPurchase.instance.endConnection;
  }

  @override
  Widget build(BuildContext context) {
    print("Purchases on build" + _purchases.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.Colors.midnightBlue,
      ),
      backgroundColor: Theme.Colors.midnightBlue,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100),
            (_purchases.length == 0 || _purchases[0].transactionId.toString() == "null")
                ? _notPaidUI(uid, context)
                : _purchaseComplete(context: context)
          ],
        ),
      ),
    );
  }

  // Private methods go here

  Widget _purchaseComplete({@required BuildContext context}) {
    print("Purchase complete, $_purchases");
    return AlertDialog(
      backgroundColor: Theme.Colors.midnightBlue,
      actions: <Widget>[
        FlatButton(
          child: Text("LET'S GO!",
              style: TextStyle(fontSize: 18, color: Colors.white)),
          color: Colors.white.withOpacity(.30),
          onPressed: () {
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
  }

  Widget _notPaidUI(String uid, BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 50),
        Center(
            child: IconButton(
                icon: Icon(Icons.lock_open, color: Theme.Colors.mustard),
                iconSize: MediaQuery.of(context).size.width / 3,
                onPressed: () {
                  _requestPurchase(_items[0]);
                })),
        RaisedButton(
            elevation: 7.5,
            color: Theme.Colors.mustard,
            child: Text("Unlock all cool dates"),
            onPressed: () {
              _requestPurchase(_items[0]);
            }),
                    RaisedButton(
            elevation: 7.5,
            color: Theme.Colors.mustard,
            child: Text("check purchases"),
            onPressed: () {
              _getPurchaseHistory();
            })
      ],
    );
  }

//anonymous methods

  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await _iap.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // prepare
    var result = await _iap.initConnection;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    // refresh items for android
    try {
      String msg = await _iap.consumeAllItems;
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      // var items = _purchases;
      // items.add(productItem);
      // setState(() {
      //   _purchases = items;
      // });
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
    });
    _getItems().then((_) {
      _getPurchaseHistory();
      _getPurchases();
    });
  }

  void _requestPurchase(IAPItem item) {
    _iap.requestPurchase(item.productId);
  }

  validateReceipt(PurchasedItem purchased) async {
      FirebaseUser currentUser = await MainBloc().getCurrentFirebaseUser();
      var idToken= await currentUser.getIdToken();
    if (Platform.isIOS) {
      var receiptBody = {
        'receipt-data': purchased.transactionReceipt,
      };
      var result = await _iap.validateReceiptIos(
          receiptBody: receiptBody, isTest: false);
      print(result);
      return (result.statusCode == 0);
    } else {
      //TODO: Get access token
      await _iap.validateReceiptAndroid(packageName: "com.cool.date.night", productId: "unlock_all",
       productToken: purchased.purchaseToken,
        accessToken: "???", isSubscription: false);
    }
  }
  

  Future _getPurchases() async {
    List<PurchasedItem> items = await _iap.getAvailablePurchases();
    for (var item in items) {
      if (await validateReceipt(item) == true) {
        this._purchases.add(item);
        Firestore.instance
            .collection('users')
            .document(uid)
            .updateData({"isPaid": true});
      }
    }
    setState(() {
      this._purchases = items;
    });
  }

  Future _getPurchaseHistory() async {
    List<PurchasedItem> items = await _iap.getPurchaseHistory();
    for (var item in items) {

      if (await validateReceipt(item) == true) {
        this._purchases.add(item);
        Firestore.instance
            .collection('users')
            .document(uid)
            .updateData({"isPaid": true});
      }
    }
    print("Purchases: ${this._purchases}");
    setState(() {
      this._purchases = items;
    });

    setState(() {
      this._purchases = items;
    });
  }

  Future<void> _getItems() async {
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getProducts(["unlock_all"]);

    for (var item in items) {
      this._items.add(item);
    }
  }
}
