import 'package:crypto_currency/constant/color.dart';
import 'package:crypto_currency/constant/url.dart';
import 'package:crypto_currency/model/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({super.key, required this.cryptoList});
  final List<Crypto>? cryptoList;
  @override
  State<CryptoScreen> createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  bool isLoeadingRefresh = false;
  List<Crypto>? cryptoList;
  @override
  void initState() {
    cryptoList = widget.cryptoList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Crypto Currency',
          style: TextStyle(fontFamily: 'mh', color: Colors.amber),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  _searchFilter(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search for the crypto currency name  ',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withAlpha(180),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(width: 0, style: BorderStyle.none),
                  ),
                  filled: true,
                  fillColor: greenColor,
                ),
              ),
            ),
            Visibility(
              visible: isLoeadingRefresh,
              child: Text(
                'Updating crypto currency information...',
                style: TextStyle(color: greenColor, fontFamily: 'mh'),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                backgroundColor: greenColor,
                color: blackColor,
                onRefresh: () async {
                  var resualt = await _getData();
                  setState(() {
                    cryptoList = resualt;
                  });
                },
                child: ListView.builder(
                  itemCount: cryptoList!.length,
                  itemBuilder: (context, index) {
                    return _getListTileItem(cryptoList![index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getListTileItem(Crypto crypto) {
    return ListTile(
      title: Text(crypto.name, style: TextStyle(color: greenColor)),
      subtitle: Text(crypto.symbol, style: TextStyle(color: greyColor)),
      leading: SizedBox(
        width: 30.0,
        child: Center(
          child: Text(
            crypto.rank.toString(),
            style: TextStyle(color: greyColor, fontSize: 16),
          ),
        ),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  crypto.priceUsd.toStringAsFixed(2),
                  style: TextStyle(color: greyColor, fontSize: 15),
                ),
                SizedBox(height: 2),
                Text(
                  crypto.changePercent24hr.toStringAsFixed(2),
                  style: TextStyle(
                    color: _getColorChangeText(crypto.changePercent24hr),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 50,
              child: Center(
                child: _getIconChangePercent(crypto.changePercent24hr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorChangeText(double value) {
    return value >= 0 ? greenColor : redColor;
  }

  Widget _getIconChangePercent(double value) {
    return value >= 0
        ? Icon(Icons.trending_up, size: 24, color: greenColor)
        : Icon(Icons.trending_down, size: 24, color: redColor);
  }

  Future<List<Crypto>> _getData() async {
    var response = await Dio().get(url);
    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();
    return cryptoList;
  }

  _searchFilter(String enteredWords) async {
    if (enteredWords.isEmpty) {
      setState(() {
        isLoeadingRefresh = true;
      });
      var response = await _getData();
      setState(() {
        cryptoList = response;
        isLoeadingRefresh = false;
      });
      return;
    }

    List<Crypto> cryptoResualtList = cryptoList!.where((element) {
      return element.name.toLowerCase().contains(enteredWords.toString());
    }).toList();

    setState(() {
      cryptoList = cryptoResualtList;
    });
  }
}
