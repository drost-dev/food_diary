part of 'dishes_screen_bloc.dart';

abstract class DishesScreenState extends Equatable {}

class DishesScreenLoading extends DishesScreenState {
  DishesScreenLoading();

  @override
  List<Object> get props => [];
}

class DishesScreenLoaded extends DishesScreenState {
  DishesScreenLoaded({required this.dishes});

  final List<Dish> dishes;

  @override
  List<Object> get props => [dishes];
}