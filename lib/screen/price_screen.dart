import 'package:bitcoin_ticker/components/reusableCard.dart';
import 'package:bitcoin_ticker/services/network.dart';
import 'package:bitcoin_ticker/utilities/coin_data.dart';
import 'package:bitcoin_ticker/utilities/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  PriceScreen({this.b, this.e, this.l});

  final double b, e, l;
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  NetworkHelper networkHelper = NetworkHelper();
  double _bPrice, _ePrice, _lPrice;
  String _selectedCurrency = 'AUD';

  @override
  void initState() {
    super.initState();
    _bPrice = widget.b;
    _ePrice = widget.e;
    _lPrice = widget.l;
  }

  Widget iosPicker() {
    return CupertinoPicker(
      itemExtent: 32,
      backgroundColor: Colors.lightBlue,
      onSelectedItemChanged: (selected) {
        setState(() {
          _selectedCurrency = currenciesList[selected];
          rebuild();
        });
      },
      children: cupPickerFunction(),
    );
  }

  Widget androidPicker() {
    return DropdownButton<String>(
        value: _selectedCurrency,
        items: myCurrencyLoopFunciton(),
        onChanged: (value) {
          setState(() {
            _selectedCurrency = value;
            rebuild();
          });
        });
  }

  List<DropdownMenuItem<String>> myCurrencyLoopFunciton() {
    List<DropdownMenuItem<String>> item = [];
    for (String val in currenciesList) {
      item.add(
        DropdownMenuItem(
          child: Text(val),
          value: val,
        ),
      );
    }
    return item;
  }

  List<Widget> cupPickerFunction() {
    List<Widget> items = [];
    for (String val in currenciesList) {
      items.add(
        Text(val),
      );
    }
    return items;
  }

  void rebuild() async {
    dynamic b = await networkHelper.getData(
        url: '${coinAverageGlobalPriceApiURL}BTC$_selectedCurrency');
    dynamic e = await networkHelper.getData(
        url: '${coinAverageGlobalPriceApiURL}ETH$_selectedCurrency');
    dynamic l = await networkHelper.getData(
        url: '${coinAverageGlobalPriceApiURL}LTC$_selectedCurrency');
    setState(() {
      _bPrice = b;
      _ePrice = e;
      _lPrice = l;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: <Widget>[
              ReusableCard(
                coin: 'BTC',
                price: _bPrice,
                currency: _selectedCurrency,
              ),
              ReusableCard(
                coin: 'ETH',
                price: _ePrice,
                currency: _selectedCurrency,
              ),
              ReusableCard(
                coin: 'LTC',
                price: _lPrice,
                currency: _selectedCurrency,
              ),
            ],
          ),
          Container(
            height: 90.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isAndroid ? iosPicker() : androidPicker(),
          ),
        ],
      ),
    );
  }
}
