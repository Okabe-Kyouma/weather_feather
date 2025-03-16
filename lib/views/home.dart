import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
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
  bool isLoading = true;
  bool fetchMoreData = true;
  int page = 1;

  void getTrendingWallpapers() async {
    try {
      dio.options.headers['Authorization'] = apiKey;
      final response = await dio
          .get('https://api.pexels.com/v1/curated?page=$page&per_page=14');

      response.data["photos"].forEach((ele) {
        SrcModel src = SrcModel(
            original: ele['src']['original'],
            small: ele['src']['small'],
            portrait: ele['src']['portrait']);

        wallpapers.add(
          WallpaperModel(
              photographer: ele['photographer'],
              photographer_id: ele['photographer_id'],
              photographer_url: ele['photographer_url'],
              src: src),
        );
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('Error Occurred!'),
                content: const Text('Please try Again after some time'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Okay'),
                  ),
                ],
              );
            });
      }
    }

    // if (mounted && Navigator.canPop(context)) {
    //   Navigator.pop(context);
    // }

    setState(() {
      isLoading = false;
      wallpapers;
    });
  }

  void loadMoreWallpapers() async {
    page++;
    try {
      dio.options.headers['Authorization'] = apiKey;
      final response = await dio
          .get('https://api.pexels.com/v1/curated?page=$page&per_page=14');

      response.data["photos"].forEach((ele) {
        SrcModel src = SrcModel(
            original: ele['src']['original'],
            small: ele['src']['small'],
            portrait: ele['src']['portrait']);

        wallpapers.add(
          WallpaperModel(
              photographer: ele['photographer'],
              photographer_id: ele['photographer_id'],
              photographer_url: ele['photographer_url'],
              src: src),
        );
      });

      setState(() {
        fetchMoreData = false;
        wallpapers;
      });
    } catch (e) {
      if (mounted) {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('Error Occurred!'),
                content: const Text(
                    'Couldnt Load More data!\nPlease try Again after some time'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Okay'),
                  ),
                ],
              );
            });
      }
    }
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.black45,
              ),
            )
          : SingleChildScrollView(
              child: SizedBox(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xfff5f8fd)),
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              focusNode: focusNode,
                              controller: searchController,
                              decoration: const InputDecoration(
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
                              child: const Icon(Icons.search)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
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
                    //wallpapersList(wallpapers, context),
                    SizedBox(
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        mainAxisSpacing: 6.0,
                        crossAxisSpacing: 6.0,
                        children: wallpapers.map((ele) {
                          setState(() {
                            fetchMoreData = true;
                          });
                          return wallpapersList(ele, context);
                        }).toList(),
                      ),
                    ),
                    if (fetchMoreData)
                      VisibilityDetector(
                        key: const Key('loading indicator'),
                        onVisibilityChanged: (VisibilityInfo info) {
                          if (info.visibleFraction > 0.8) {
                            //print('loading more data');
                            loadMoreWallpapers();
                            fetchMoreData = true;
                          }
                        },
                        child: Center(
                          child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 30),
                              child: const CircularProgressIndicator()),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

class CategorieTile extends StatelessWidget {
  const CategorieTile({super.key, required this.imgUrl, required this.name});

  final String imgUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
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
              style: const TextStyle(
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
