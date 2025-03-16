import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:weather_feather/views/SetAsW.dart';

class MyWallpaper extends StatefulWidget {
  const MyWallpaper({super.key, required this.img});

  final String img;

  @override
  State<MyWallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<MyWallpaper> {
  String home = "Home Screen", lock = "Lock Screen";
  String res = "Waiting to download...";
  bool downloading = false;
  late Stream<String> progressString;

  Future<void> downloadImage(BuildContext context, String url) async {
    if (downloading) return;

    try {
      setState(() {
        downloading = true;
        res = "Starting Download...";
      });

      progressString = Wallpaper.imageDownloadProgress(
        url,
        location: DownloadLocation.applicationDirectory,
      );

      progressString.listen(
        (data) {
          setState(() {
            res = data;
          });
          //print("Downloading: $data");
        },
        onDone: () {
          setState(() {
            downloading = false;
          });
          showModal();
         // print("Download Completed ✅");
        },
        onError: (error) {
          setState(() {
            downloading = false;
          });
          showSnackbar("Download Failed! ❌ Check your internet.");
          //print("Download Error ❌: $error");
        },
      );
    } catch (e) {
      setState(() => downloading = false);
      showSnackbar("Unexpected error: $e");
      //print("Exception Occurred: $e");
    }
  }

  void showModal() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SetAsW(
          onHomeScreen: () async {
            showDialog(
                context: context,
                builder: (context) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                  ;
                });

            try {
              await Wallpaper.homeScreen(
                options: RequestSizeOptions.resizeFit,
                width: width,
                location: DownloadLocation.applicationDirectory,
                height: height,
              );
              Navigator.pop(context);

              Fluttertoast.showToast(
                  msg: "Wallpaper Set ✅", toastLength: Toast.LENGTH_LONG);
            } catch (e) {
              Fluttertoast.showToast(
                  msg: "Failed to set wallpaper ❌",
                  toastLength: Toast.LENGTH_LONG);
             // print("Wallpaper Error: $e");
            }
          },
          onLockScreen: () async {
            showDialog(
                context: context,
                builder: (context) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                });
            try {
              await Wallpaper.lockScreen(
                location: DownloadLocation.applicationDirectory,
                width: width,
                height: height,
              );
              Navigator.pop(context);

              Fluttertoast.showToast(
                  msg: "Wallpaper Set ✅", toastLength: Toast.LENGTH_LONG);
            } catch (e) {
              Fluttertoast.showToast(
                  msg: "Failed to set wallpaper ❌",
                  toastLength: Toast.LENGTH_LONG);
              //print("Wallpaper Error: $e");
            }
          },
        );
      },
    ).whenComplete(() {
      setState(() {});
    });
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget imageDownloadDialog() {
    return SizedBox(
      height: 120.0,
      width: 200.0,
      child: Card(
        color: Colors.black45,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(),
            const SizedBox(height: 10.0),
            Text(
              "Downloading: $res",
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  void saveImageFromUrl(String imageUrl) async {
    //print("asking for permission");

    PermissionStatus request = await Permission.photos.request();

    //print("asked for permission");

    if (request.isDenied) {
      showSnackbar("Please Provide Storage Permission In Settings");
      //print("denied");
      return;
    }

    if (request.isGranted) {
     //print("granted");
      try {
        Dio dio = Dio();

        Response response = await dio.get(
          imageUrl,
          options: Options(responseType: ResponseType.bytes),
        );

        Uint8List imageData = Uint8List.fromList(response.data);

        final result = await SaverGallery.saveImage(
          imageData,
          quality: 100,
          fileName: "saved_image",
          androidRelativePath: "Pictures/appName/images",
          skipIfExists: false,
        );

        showSnackbar("Image saved successfully! 🎉");
      } catch (e) {
        showSnackbar("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: widget.img,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.img,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(
                  icon: Icons.wallpaper,
                  text: "Set As Wallpaper",
                  onTap: () async {
                    await downloadImage(context, widget.img);
                  },
                ),
                const SizedBox(width: 20),
                _buildButton(
                  icon: Icons.photo,
                  text: "Save in Gallery",
                  onTap: () {
                    //print('this envoking');
                    saveImageFromUrl(widget.img);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 1.06,
            left: MediaQuery.of(context).size.width / 2.5,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.only(bottom: 30),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          if (downloading) Center(child: imageDownloadDialog()),
        ],
      ),
    );
  }

  Widget _buildButton(
      {required IconData icon, required String text, VoidCallback? onTap}) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(text),
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: onTap == null ? Colors.white : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
