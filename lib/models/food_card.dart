import 'package:food_diary_app/models/dish.dart';

class FoodCard {
  FoodCard({
    this.id,
    required this.name,
    required this.dishes,
    this.imgPath = 'null',
  });

  int? id;
  String name;
  List<Dish> dishes;
  String imgPath;
}
