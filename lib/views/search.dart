import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_feather/model/api_key.dart';
import 'package:weather_feather/model/wallpaper_model.dart';
import 'package:weather_feather/widgets/widget.dart';

class Search extends StatefulWidget {
  const Search({super.key, required this.searchQuery});

  final String searchQuery;

  @override
  State<Search> createState() {
    return _SearchState();
  }
}

class _SearchState extends State<Search> {
  List<WallpaperModel> wallpapers = [];

  void searchQueryWall() async {
    String qs = widget.searchQuery;
    Dio dio = new Dio();

    dio.options.headers['Authorization'] = apiKey;
    final response =
        await dio.get('https://api.pexels.com/v1/search?query=$qs&per_page=15');

    response.data["photos"].forEach((ele) {
      SrcModel src = SrcModel(
          original: ele['src']['original'],
          small: ele['src']['small'],
          portrait: ele['src']['portrait']);

      wallpapers.add(
        new WallpaperModel(
            photographer: ele['photographer'],
            photographer_id: ele['photographer_id'],
            photographer_url: ele['photographer_url'],
            src: src),
      );
    });

    setState(() {
      wallpapers;
    });
  }

  @override
  void initState() {
    super.initState();
    searchQueryWall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BrandName(),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              wallpapersList(wallpapers, context),
            ],
          ),
        ),
      ),
    );
  }
}
