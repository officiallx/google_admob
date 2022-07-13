import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AdRequest? adRequest;
  BannerAd? bannerAd;

  @override
  void initState() {
    super.initState();

    String bannerId =  Platform.isAndroid?"ca-app-pub-6215194926274787/9856206856":"ca-app-pub-3940256099942544/2934735716";

    adRequest = const AdRequest(
    );

    BannerAdListener bannerAdListener = BannerAdListener(
      onAdLoaded: (ad){
        bannerAd!.load();
      },
      onAdClosed: (ad){
        bannerAd!.load();
      },
      onAdFailedToLoad: (ad,error){
        bannerAd!.load();
        print("Load Error $error");
      },
    );
    bannerAd = BannerAd(size:AdSize.banner, adUnitId: bannerId, listener: bannerAdListener, request: adRequest!,);

    bannerAd!.load();
  }

  @override
  void dispose() {
    bannerAd!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text("Hello"),color: Colors.grey,),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: AdWidget(ad: bannerAd!))
        ],
      ),
    );
  }
}
