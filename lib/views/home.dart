import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_feather/data/data.dart';
import 'package:weather_feather/model/api_key.dart';
import 'package:weather_feather/model/categories_model.dart';
import 'package:weather_feather/model/wallpaper_model.dart';
import 'package:weather_feather/widgets/widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  List<CategoriesModel> myList = getCategories();
  List<WallpaperModel> wallpapers = [];
  List<SrcModel> srcModels = [];
  final Dio dio = Dio();

  void getTrendingWallpapers() async {
    dio.options.headers['Authorization'] = apiKey;
    final response = await dio.get('https://api.pexels.com/v1/curated');
    //print(response.data.toString());

    // String jsonData = jsonDecode(response.data);

    //print('response.........................${response.data['photos'][1]}');

    response.data["photos"].forEach((ele) {
      print('response.........................${ele['photographer']}');

      srcModels.add(
        new SrcModel(
            original: ele['src'].original,
            small: ele['src'].small,
            portrait: ele['src'].portrait),
      );

      wallpapers.add(
        new WallpaperModel(
            photographer: ele['photographer'],
            photographer_id: ele['photographer_id'],
            photographer_url: ele['photographer_url'],
            src: ele['src']),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getTrendingWallpapers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BrandName(),
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xfff5f8fd)),
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Wallpaper',
                      ),
                    ),
                  ),
                  InkWell(child: Icon(Icons.search)),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              height: 80,
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: myList.length,
                itemBuilder: (context, index) {
                  return CategorieTile(
                      imgUrl: myList[index].imgUrl,
                      name: myList[index].categoriesName);
                },
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: wallpapers.length,
                itemBuilder: (context, index) {
                  return Text(wallpapers[index].photographer);
                })
          ],
        ),
      ),
    );
  }
}

class CategorieTile extends StatelessWidget {
  CategorieTile({super.key, required this.imgUrl, required this.name});

  String imgUrl;
  String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imgUrl,
              height: 50,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black26,
            height: 50,
            width: 100,
            alignment: Alignment.center,
            child: Text(
              name,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
