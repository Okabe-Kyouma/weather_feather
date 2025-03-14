class WallpaperModel {
  WallpaperModel(
      {required this.photographer,
      required this.photographer_id,
      required this.photographer_url,
      required this.src});

  String photographer;
  String photographer_url;
  int photographer_id;
  SrcModel src;
}

class SrcModel {
  SrcModel(
      {required this.original, required this.small, required this.portrait});
  String original;
  String small;
  String portrait;
}
