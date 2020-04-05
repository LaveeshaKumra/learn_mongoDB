 import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:learningapp/detail.dart';
import 'package:learningapp/splash.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
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
      ) ?? false;
    }


  @override
  Widget build(BuildContext context) {
    FirebaseAdMob.instance.initialize(appId: "ca-app-pub-6216078565461407~5761490509").then(
        (response){
          myBanner..load()..show();
        }
    );
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Learn MongoDB'),
//          actions: <Widget>[
//
//            PopupMenuButton(
//              itemBuilder: (context) => [
//                PopupMenuItem(
//                  value: 1,
//                  child: Text("Rate app"),
//                ),
//                PopupMenuItem(
//                  value: 2,
//                  child: Text("Share"),
//                ),
//              ],
//            )
//          ],
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPage(index)));
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
                      child: CircularProgressIndicator(),
                      width: 40,
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text("Loading.."),
                    )
                  ],
                );
              }
            },
            future: DefaultAssetBundle.of(context).loadString("assets/data.json"),
          ),
        ),
      ),
    );
  }
}


MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['Learn', 'MongoDb'],
  contentUrl: 'https://flutter.io',
  birthday: DateTime.now(),
  childDirected: false,
  designedForFamilies: false,
  gender: MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
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