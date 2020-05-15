import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:learningapp/detail.dart';
import 'package:learningapp/splash.dart';
import 'package:share/share.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';
import 'package:connectivity/connectivity.dart';
import 'Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var mode;
  SharedPreferences prefs=await SharedPreferences.getInstance();
  var val=prefs.getBool("mode");
  if(val=true){
    mode=MyThemeKeys.DARKER;
  }
  else{
    mode=MyThemeKeys.LIGHT;
  }
  runApp(
    CustomTheme(
      initialThemeKey: mode,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Learn MongoDB",
//      theme: ThemeData(
//        primarySwatch: Colors.green,
//      ),
      theme: CustomTheme.of(context),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(){
      data=_get();
    _checkconnectivity();
      _firstloaded();
  }
  final keyIsFirstLoaded = 'is_first_loaded';
  var clickes=0;
  var data;
  var darkmode;

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  _firstloaded() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLoaded = prefs.getBool(keyIsFirstLoaded);
    if (isFirstLoaded == null) {
      prefs.setBool("mode", false);
      prefs.setBool(keyIsFirstLoaded, false);
    }
  }



  _checkconnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("No internet Connection"),
              content: Text("Check your internet connection"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok',style: TextStyle(color: Colors.green)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }
  InterstitialAd myInterstitial;

  InterstitialAd buildInterstitialAd() {
    return InterstitialAd(
      //adUnitId: InterstitialAd.testAdUnitId,
      adUnitId: "ca-app-pub-6216078565461407/7814731755",
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          myInterstitial..load();
        } else if (event == MobileAdEvent.closed) {
          myInterstitial = buildInterstitialAd()..load();
        }
        print(event);
      },
    );
  }

  void showInterstitialAd() {
    myInterstitial.show();
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<String> _get() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      darkmode=prefs.getBool("mode");
    });
    Response response = await get("https://raw.githubusercontent.com/devatomdata/data1mongo/master/data1");
  if(response.statusCode==200){
    print(response.body);
  }
  return response.body;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-6216078565461407~5761490509");
    _bannerAd=myBanner..load()..show();
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Learn MongoDB'),
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  child: darkmode==false?Text("Enable Dark Mode"):Text("Disable Dark Mode"),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text("Rate app"),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text("Share"),
                ),
//                PopupMenuItem(
//                  value: 3,
//                  child: Text("Learn fullstack development : A beginner's guide"),
//                ),
                PopupMenuItem(
                  value: 4,
                  child: Text("More Apps"),
                ),
              ],
              onSelected: (val) async {
                if (val == 1) {
                  LaunchReview.launch(
                    androidAppId: "com.quest.learnmongo",
                  );
                }
                else if (val == 0) {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  setState(() {
                    if(darkmode==false) {
                      prefs.setBool("mode", true);
                      _get();
                      _changeTheme(context, MyThemeKeys.DARKER);
                    }
                    else {
                      prefs.setBool("mode", false);
                      _get();
                      _changeTheme(context, MyThemeKeys.LIGHT);
                    }

                  });
                }
//                else if (val == 3) {
//                  LaunchReview.launch(
//                    androidAppId: "dev.learn.mernstack",
//                  );
//                }
                else if (val == 4) {
                  launch(
                      "https://play.google.com/store/apps/developer?id=DevAtom");
                } else {
                  Share.share(
                      'Learn mongoDB anytime,anywhere(offline app).Now learning is at your fingertips. Install this Awesome app\nhttps://play.google.com/store/apps/details?id=com.quest.learnmongo',
                      subject: 'Learn MongoDB');
                }
              },
            )
          ],
        ),
        body: Center(
          child: FutureBuilder(
            builder: (context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                var showData = json.decode(snapshot.data.toString());
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Text(showData[index]['title']),
                        onTap: () {
                          if(_bannerAd.isLoaded()!=null){
                            try {
                              _bannerAd?.dispose();
                            } catch (ex) {}
                          }
                          setState(() {
                            clickes++;
                          });
                          print(clickes);
                          if(clickes%3==0){
                            showInterstitialAd();
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPage(index))).then((_) {
                            if(_bannerAd.isLoaded()!=null){
                              try {
                                _bannerAd?.dispose();
                              } catch (ex) {}
                              _bannerAd..load()..show();
                            }

                          });
                        },
                      ),
                    );
                  },
                  itemCount: showData.length,
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      child: CircularProgressIndicator(
//                          valueColor: new AlwaysStoppedAnimation<Color>(
//                              Colors.green)
                      ),
                      width: 30,
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text("Loading.."),
                    )
                  ],
                );
              }
            },
            future:
              data
                //DefaultAssetBundle.of(context).loadString("assets/data.json"),
          ),
        ),
      ),
    );
  }
  BannerAd _bannerAd;
  @override
  void initState() {
    setState(() {
      data=_get();
    });
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-6216078565461407~5761490509");
    _bannerAd=myBanner..load()..show();
    myInterstitial = buildInterstitialAd()..load();

  }

  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['Learn', 'MongoDb'],
    contentUrl: 'https://flutter.io',
    birthday: DateTime.now(),
    childDirected: false,
    designedForFamilies: false,
    gender:
    MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
    testDevices: <String>[], // Android emulators are considered test devices
  );

  BannerAd myBanner = BannerAd(
    // Replace the testAdUnitId with an ad unit id from the AdMob dash.
    // https://developers.google.com/admob/android/test-ads
    // https://developers.google.com/admob/ios/test-ads
    adUnitId: "ca-app-pub-6216078565461407/6308285418",
    //adUnitId: BannerAd.testAdUnitId,
    size: AdSize.smartBanner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }


}
