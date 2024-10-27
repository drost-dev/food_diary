import 'package:food_diary_app/models/food_card.dart';

class Day {
  Day({
    required this.id,
    required this.name,
    required this.foodCards,
  });

  int id;
  String name;
  List<FoodCard> foodCards;
}
