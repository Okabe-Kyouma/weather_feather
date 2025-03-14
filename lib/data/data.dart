import 'package:weather_feather/model/categories_model.dart';




List<CategoriesModel> getCategories() {
  List<CategoriesModel> categories = [
    CategoriesModel(
        categoriesName: 'Nature',
        imgUrl:
            'https://images.pexels.com/photos/906150/pexels-photo-906150.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
    CategoriesModel(
        categoriesName: 'Wild Life',
        imgUrl:
            'https://images.pexels.com/photos/3635178/pexels-photo-3635178.jpeg?auto=compress&cs=tinysrgb&w=600'),
    CategoriesModel(
        categoriesName: 'City',
        imgUrl:
            'https://images.pexels.com/photos/417344/pexels-photo-417344.jpeg?auto=compress&cs=tinysrgb&w=600'),
    CategoriesModel(
        categoriesName: 'Culture',
        imgUrl:
            'https://images.pexels.com/photos/1033202/pexels-photo-1033202.jpeg?auto=compress&cs=tinysrgb&w=600'),
    CategoriesModel(
        categoriesName: 'Aesthetics',
        imgUrl:
            'https://images.pexels.com/photos/315191/pexels-photo-315191.jpeg?auto=compress&cs=tinysrgb&w=600'),
    CategoriesModel(
        categoriesName: 'Cars',
        imgUrl:
            'https://images.pexels.com/photos/3311574/pexels-photo-3311574.jpeg?auto=compress&cs=tinysrgb&w=600')
  ];

  return categories;
}
