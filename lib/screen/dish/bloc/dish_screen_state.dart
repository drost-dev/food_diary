part of 'dish_screen_bloc.dart';

abstract class DishScreenState extends Equatable {}

class DishScreenLoading extends DishScreenState {
  DishScreenLoading();

  @override
  List<Object> get props => [];
}

class DishScreenLoaded extends DishScreenState {
  DishScreenLoaded({required this.components});

  final List<Component> components;

  @override
  List<Object> get props => [components];
}