import 'package:flutter/material.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:weather_feather/views/SetAsW';

class MyWallpaper extends StatefulWidget {
  const MyWallpaper({super.key, required this.img});

  final String img;

  @override
  State<MyWallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<MyWallpaper> {
  String home = "Home Screen", lock = "Lock Screen";
  String res = "Waiting to download...";
  bool _isDisable = true;
  bool downloading = false;
  late Stream<String> progressString;

  Future<void> downloadImage(BuildContext context, String url) async {
    if (downloading) return; // Prevent multiple clicks

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
          print("Downloading: $data");
        },
        onDone: () {
          setState(() {
            downloading = false;
            _isDisable = false;
          });
          showModal();
          print("Download Completed ✅");
        },
        onError: (error) {
          setState(() {
            downloading = false;
            _isDisable = true;
          });
          showSnackbar("Download Failed! ❌ Check your internet.");
          print("Download Error ❌: $error");
        },
      );
    } catch (e) {
      setState(() => downloading = false);
      showSnackbar("Unexpected error: $e");
      print("Exception Occurred: $e");
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
            try {
              await Wallpaper.homeScreen(
                options: RequestSizeOptions.resizeFit,
                width: width,
                location: DownloadLocation.applicationDirectory,
                height: height,
              );
              showSnackbar("Wallpaper Set ✅");
            } catch (e) {
              showSnackbar("Failed to set wallpaper ❌");
              print("Wallpaper Error: $e");
            }
          },
          onLockScreen: () async {
            try {
              await Wallpaper.lockScreen(
                location: DownloadLocation.applicationDirectory,
                width: width,
                height: height,
              );
              showSnackbar("Lock Screen Set ✅");
            } catch (e) {
              showSnackbar("Failed to set lock screen ❌");
              print("Lock Screen Error: $e");
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
        color: Colors.black,
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
            bottom: 50,
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
                    showSnackbar("Feature not implemented! 🛠");
                  },
                ),
              ],
            ),
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
