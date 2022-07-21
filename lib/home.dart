import 'package:flutter/material.dart';
import 'package:google_admob/ad_helper.dart';
import 'package:google_admob/classifier.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  AdRequest? adRequest;
  BannerAd? bannerAd;
  InterstitialAd? _interstitialAd;
  final Classifier _classifier = Classifier();
  var response;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    adRequest = const AdRequest(nonPersonalizedAds: false);
    _createBannerAd();
    _createInterstitialAd();
  }

  void _createBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerAd!.load();
        },
        onAdClosed: (ad) {
          bannerAd!.load();
        },
        onAdFailedToLoad: (ad, error) {
          bannerAd!.load();
          print("Load Error $error");
        },
      ),
      request: adRequest!,
    );

    bannerAd!.load();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: adRequest!,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
          _createInterstitialAd();
          print("InterstitialAd load failed : $error");
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
    }
  }

  @override
  void dispose() {
    bannerAd!.dispose();
    _interstitialAd!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 1.2,
        title: const Text(
          "Home",
          style: TextStyle(fontSize: 14),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(hintText: "Your Opinion"),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text("   Positive: ${response != null ? response[1] : 0}"),
                  Text("   Negative: ${response != null ? response[0] : 0}"),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                    ),
                    onPressed: () {
                      response = _classifier.classify(_controller.text);
                      print("Positive: ${response[1]}");
                      print("Negative: ${response[0]}");
                      setState(() {});
                      //_showInterstitialAd();
                    },
                    child: const Text("Int"),
                  ),
                ],
              ),
            ),
          ),
          // SizedBox(
          //   width: size.width,
          //   height: 60,
          //   child: AdWidget(ad: bannerAd!),
          // )
        ],
      ),
    );
  }
}
