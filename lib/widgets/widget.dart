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

Widget wallpapersList(List<WallpaperModel> wallpapers, context) {
  return SizedBox(
    child: GridView.count(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      children: wallpapers.map((ele) {
        return GridTile(
          child: SizedBox(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Wallpaper(img: ele.src.portrait),
                    ));
              },
              child: Hero(
                tag: ele.src.portrait,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    ele.src.portrait,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
