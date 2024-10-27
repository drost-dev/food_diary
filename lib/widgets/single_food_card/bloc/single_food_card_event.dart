part of 'single_food_card_bloc.dart';

abstract class SingleFoodCardEvent extends Equatable {}

class SingleFoodCardLoad extends SingleFoodCardEvent {
  SingleFoodCardLoad({required this.foodCard});

  final FoodCard foodCard;

  @override
  List<Object> get props => [foodCard];
}

class SingleFoodCardAddDish extends SingleFoodCardEvent {
  SingleFoodCardAddDish({required this.foodCard});

  final FoodCard foodCard;

  @override
  List<Object> get props => [foodCard];
}

class SingleFoodCardUpdate extends SingleFoodCardEvent {
  SingleFoodCardUpdate({
    required this.oldFoodCard,
    required this.newFoodCard,
  });

  final FoodCard oldFoodCard;
  final FoodCard newFoodCard;

  @override
  List<Object> get props => [
        oldFoodCard,
        newFoodCard,
      ];
}

class SingleFoodCardDelete extends SingleFoodCardEvent {
  SingleFoodCardDelete({required this.foodCard});

  final FoodCard foodCard;

  @override
  List<Object> get props => [foodCard];
}
