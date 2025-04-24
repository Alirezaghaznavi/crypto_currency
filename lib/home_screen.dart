import 'package:crypto_currency/constant/url.dart';
import 'package:crypto_currency/model/crypto.dart';
import 'package:crypto_currency/crypto_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Image.asset('assets/images/logo.png'),
            SpinKitThreeBounce(color: Colors.white, size: 42.0),
          ],
        ),
      ),
    );
  }

  Future _getData() async {
    Response response = await Dio().get(url);
    List<Crypto> cryptoList =
        response.data['data'].map<Crypto>((jsonMapObject) {
      return Crypto.fromMapJson(jsonMapObject);
    }).toList();

    navigatorPush(cryptoList);
  }

  navigatorPush(List<Crypto> cryptoList) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => CryptoScreen(cryptoList: cryptoList)),
    );
  }
}
