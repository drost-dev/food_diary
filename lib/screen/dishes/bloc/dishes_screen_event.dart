part of 'dishes_screen_bloc.dart';

abstract class DishesScreenEvent extends Equatable {}

class DishesScreenLoad extends DishesScreenEvent {
  DishesScreenLoad();

  @override
  List<Object> get props => [];
}

class DishesScreenDelete extends DishesScreenEvent {
  DishesScreenDelete({
    required this.dish,
  });

  final Dish dish;

  @override
  List<Object> get props => [dish];
}