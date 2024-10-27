import 'package:food_diary_app/models/nutrients.dart';

class Component {
  Component({
    this.id,
    this.name = 'Безымянный',
    required this.nutrients,
    this.imgPath,
    this.amount = 0,
  });

  int? id;
  String name;
  Nutrients nutrients;
  double amount;
  String? imgPath;
}
