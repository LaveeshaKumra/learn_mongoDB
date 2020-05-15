import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:http/http.dart';
import 'package:connectivity/connectivity.dart';

class DetailPage extends StatefulWidget {
  static int index;

  DetailPage(int s) {
    index = s;
   // loadCrossword();
  }
  @override
  _DetailPageState createState() => _DetailPageState(index);
}

class _DetailPageState extends State<DetailPage> {
  static int index;
  _DetailPageState(int i) {
    index = i;
    _get();
    _checkconnectivity();
  }

  var clickes=0;

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
  BannerAd _bannerAd;
  Future<String> _get() async{
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


    return FutureBuilder(builder: (context, AsyncSnapshot snapshot)
    {
      if (snapshot.hasData) {
        var showData = json.decode(snapshot.data.toString());
      return Scaffold(
        appBar: AppBar(
          title: Text(showData[index]['title']),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(child: Text("${showData[index]['data']}")),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(child: Text("${showData[index]['subtype1']}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),)),
                ),
                Container(child: Text("${showData[index]['data1']}")),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(child: Text("${showData[index]['subtype2']}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),)),
                ),
                Container(child: Text("${showData[index]['data2']}")),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(child: Text("${showData[index]['subtype3']}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),)),
                ),
                Container(child: Text("${showData[index]['data3']}")),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(child: Text("${showData[index]['subtype4']}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),)),
                ),
                Container(child: Text("${showData[index]['data4']}")),

              ],
            ),
          ),
        ),
      );
    }
    else{
        return FutureBuilder(
          future: Future.delayed(Duration(milliseconds: 5000)),
          builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done){
              return Center(
                child: Text(
                  "Something went wrong\nPlease Try again later",
                  style: TextStyle(color: Colors.green),
                ),
              );
            }
            else{
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        child: CircularProgressIndicator(
//                            valueColor: new AlwaysStoppedAnimation<Color>(
//                                Colors.green)
                        ),
                        width: 30,
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text("Loading.."),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        );
      }
    }, future: _get(),
    );
    }


  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['Learn', 'MongoDb'],
    contentUrl: 'https://flutter.io',
    birthday: DateTime.now(),
    childDirected: false,
    designedForFamilies: false,
    gender: MobileAdGender.female,
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
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  void initState() {
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-6216078565461407~5761490509");
    _bannerAd=myBanner..load()..show();
  }


}

