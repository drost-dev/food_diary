part of 'dish_screen_bloc.dart';

abstract class DishScreenEvent extends Equatable {}

class DishScreenLoad extends DishScreenEvent {
  DishScreenLoad();

  @override
  List<Object> get props => [];
}

class DishScreenAdd extends DishScreenEvent {
  DishScreenAdd({
    required this.dish,
  });

  final Dish dish;

  @override
  List<Object> get props => [
        dish,
      ];
}
