import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_admob/firebase_admob.dart';

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
  }




  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (context, AsyncSnapshot snapshot)
    {
      if (snapshot.hasData) {
        var showData = json.decode(snapshot.data.toString());
      return Scaffold(
        appBar: AppBar(
          title: Text(showData[index]['title']),
//          actions: <Widget>[
//            IconButton(
//              icon: Icon(Icons.file_download),
//              onPressed: () {
//                print("download");
//              },
//            )
//          ],
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
    }, future: DefaultAssetBundle.of(context).loadString("assets/data.json"),
    );
    }
  }

