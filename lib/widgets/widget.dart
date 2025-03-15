import 'package:flutter/material.dart';
import 'package:weather_feather/model/wallpaper_model.dart';
import 'package:weather_feather/views/wallpaper.dart';

Widget BrandName() {
  return const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Wally',
        style: TextStyle(color: Colors.black87),
      ),
      Text(
        'Pep',
        style: TextStyle(color: Colors.blue),
      )
    ],
  );
}

Widget wallpapersList(WallpaperModel wallpaper, context) {

  return GridTile(
          child: SizedBox(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyWallpaper(img: wallpaper.src.portrait),
                    ));
              },
              child: Hero(
                tag: wallpaper.src.portrait,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    wallpaper.src.portrait,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );

}
