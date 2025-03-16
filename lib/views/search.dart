import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
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
  bool isLoading = true;
  bool fetchMoreData = true;
  int page = 1;
  Dio dio = Dio();

  void searchQueryWall() async {
    String qs = widget.searchQuery;

    try {
      dio.options.headers['Authorization'] = apiKey;
      final response = await dio
          .get('https://api.pexels.com/v1/search?query=$qs&per_page=15');

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

    setState(() {
      isLoading = false;
      wallpapers;
    });
  }

  void loadMoreWallpapers() async {
    String qs = widget.searchQuery;

   
    try {
       page++;
      dio.options.headers['Authorization'] = apiKey;
      final response = await dio
          .get('https://api.pexels.com/v1/search?query=$qs&page=$page&per_page=14');

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
    searchQueryWall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BrandName(),
        elevation: 0.0,
      ),
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
