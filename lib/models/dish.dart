import 'package:food_diary_app/models/component.dart';
import 'package:food_diary_app/models/nutrients.dart';

class Dish {
  Dish({
    this.id,
    this.name = 'Без названия',
    required this.nutrients,
    required this.components,
    this.imgPath,
  });

  int? id;
  String name;
  Nutrients nutrients;
  List<Component> components;
  String? imgPath;
}
