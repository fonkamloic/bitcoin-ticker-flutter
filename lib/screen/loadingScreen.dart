import 'package:bitcoin_ticker/utilities/constant.dart';
import 'package:bitcoin_ticker/screen/price_screen.dart';
import 'package:flutter/material.dart';
import 'package:bitcoin_ticker/services/network.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  double bData, eData, lData;
  NetworkHelper networkHelper = NetworkHelper();
  @override
  void initState() {
    super.initState();
    getCoinData();
  }

  void getCoinData() async {
    bData = await networkHelper.getData(
        url: '${coinAverageGlobalPriceApiURL}BTCUSD');

    eData = await networkHelper.getData(
        url: '${coinAverageGlobalPriceApiURL}ETHUSD');

    lData = await networkHelper.getData(
        url: '${coinAverageGlobalPriceApiURL}LTCUSD');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PriceScreen(b: bData, e: eData, l: lData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SpinKitRotatingCircle(
      color: Colors.lightBlue,
      size: 100.0,
    );
  }
}
