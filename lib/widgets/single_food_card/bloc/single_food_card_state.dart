part of 'single_food_card_bloc.dart';

abstract class SingleFoodCardState extends Equatable {}

class SingleFoodCardLoading extends SingleFoodCardState {
  SingleFoodCardLoading();

  @override
  List<Object> get props => [];
}

class SingleFoodCardLoaded extends SingleFoodCardState {
  SingleFoodCardLoaded({
    required this.dishes,
    required this.allDishes,
  });

  final List<Dish> dishes;
  final List<Dish> allDishes;

  @override
  List<Object> get props => [dishes];
}
