import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wallpaper/wallpaper.dart';

class WallpaperAction extends StatefulWidget {
  const WallpaperAction({super.key});

  @override
  State<WallpaperAction> createState() {
    return _WallpaperActionState();
  }
}

class _WallpaperActionState extends State<WallpaperAction> {
  String home = "Home Screen",
      lock = "Lock Screen",
      both = "Both Screen",
      system = "System";

  late Stream<String> progressString;
  late String res;
  bool downloading = false;
  List<String> images = [
    "https://images.pexels.com/photos/1624496/pexels-photo-1624496.jpeg",
    "https://images.pexels.com/photos/1496373/pexels-photo-1496373.jpeg",
    "https://images.pexels.com/photos/1366919/pexels-photo-1366919.jpeg",
    "https://images.pexels.com/photos/1526713/pexels-photo-1526713.jpeg",
    "https://images.pexels.com/photos/1535162/pexels-photo-1535162.jpeg",
    "https://images.pexels.com/photos/2670898/pexels-photo-2670898.jpeg",
    "https://images.pexels.com/photos/1366630/pexels-photo-1366630.jpeg"
  ];
  var result = "Waiting to set wallpaper";
  bool _isDisable = true;

  int nextImageID = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: const EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                downloading
                    ? imageDownloadDialog()
                    : Image.network(
                        images[nextImageID],
                        fit: BoxFit.fitWidth,
                      ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      nextImageID = Random().nextInt(images.length);
                      _isDisable = true;
                    });
                  },
                  child: const Text("Get Random Image"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    return await downloadImage(context,'fs');
                  },
                  child: const Text("Please download the image"),
                ),
                ElevatedButton(
                  onPressed: _isDisable
                      ? null
                      : () async {
                          var width = MediaQuery.of(context).size.width;
                          var height = MediaQuery.of(context).size.height;
                          home = await Wallpaper.homeScreen(
                              options: RequestSizeOptions.resizeFit,
                              width: width,
                              location: DownloadLocation.applicationDirectory,
                              height: height);
                          setState(() {
                            downloading = false;
                            home = home;
                          });
                          //print("Task Done");
                        },
                  child: Text(home),
                ),
                ElevatedButton(
                  onPressed: _isDisable
                      ? null
                      : () async {
                          lock = await Wallpaper.lockScreen(
                            location: DownloadLocation.applicationDirectory,
                          );
                          setState(() {
                            downloading = false;
                            lock = lock;
                          });
                          //print("Task Done");
                        },
                  child: Text(lock),
                ),
                ElevatedButton(
                  onPressed: _isDisable
                      ? null
                      : () async {
                          both = await Wallpaper.bothScreen(
                            location: DownloadLocation.applicationDirectory,
                          );
                          setState(() {
                            downloading = false;
                            both = both;
                          });
                          //print("Task Done");
                        },
                  child: Text(both),
                ),
                ElevatedButton(
                  onPressed: _isDisable
                      ? null
                      : () async {
                          system = await Wallpaper.systemScreen(
                            location: DownloadLocation.applicationDirectory,
                          );
                          setState(() {
                            downloading = false;
                            system = system;
                          });
                          //print("Task Done");
                        },
                  child: Text(system),
                ),
              ],
            ),
          )),
    );
  }

  Future<void> downloadImage(BuildContext context,String url) async {

    progressString = Wallpaper.imageDownloadProgress(
      images[nextImageID],
      location: DownloadLocation.applicationDirectory,
    );
    progressString.listen((data) {
      setState(() {
        res = data;
        downloading = true;
      });
      //print("DataReceived: " + data);
    }, onDone: () async {
      setState(() {
        downloading = false;
        _isDisable = false;
      });
      //print("Task Done");
    }, onError: (error) {
      setState(() {
        downloading = false;
        _isDisable = true;
      });
     // print("Some Error");
    });
  }

  Widget imageDownloadDialog() {
    return SizedBox(
      height: 120.0,
      width: 200.0,
      child: Card(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(),
            const SizedBox(height: 20.0),
            Text(
              "Downloading File : $res",
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
