import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
  bool isLoading = true;

  void searchQueryWall() async {
    String qs = widget.searchQuery;
    Dio dio = Dio();

   try{

    dio.options.headers['Authorization'] = apiKey;
    final response =
        await dio.get('https://api.pexels.com/v1/search?query=$qs&per_page=15');

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

     }catch(e){
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
                    wallpapersList(wallpapers, context),
                  ],
                ),
              ),
            ),
    );
  }
}
