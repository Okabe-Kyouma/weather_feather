import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_feather/data/data.dart';
import 'package:weather_feather/model/api_key.dart';
import 'package:weather_feather/model/categories_model.dart';
import 'package:weather_feather/model/wallpaper_model.dart';
import 'package:weather_feather/views/category.dart';
import 'package:weather_feather/views/search.dart';
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
  final Dio dio = Dio();
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();

  void getTrendingWallpapers() async {
    dio.options.headers['Authorization'] = apiKey;
    final response = await dio.get('https://api.pexels.com/v1/curated');

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
      body: SingleChildScrollView(
        child: Container(
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
                        focusNode: focusNode,
                        controller: searchController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search Wallpaper',
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          focusNode.unfocus();

                          String query = searchController.text.trim();

                          if (query.isNotEmpty) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Search(
                                          searchQuery: query,
                                        ))).then((_) {
                              searchController.clear();
                            });
                          }
                        },
                        child: Icon(Icons.search)),
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
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Category(
                                category: myList[index].categoriesName),
                          ),
                        );
                      },
                      child: CategorieTile(
                          imgUrl: myList[index].imgUrl,
                          name: myList[index].categoriesName),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              wallpapersList(wallpapers, context),
            ],
          ),
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black26,
            ),
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
