part of 'home_screen_bloc.dart';

abstract class HomeScreenState extends Equatable {}

class HomeScreenLoading extends HomeScreenState {
  HomeScreenLoading();

  @override
  List<Object> get props => [];
}

class HomeScreenLoaded extends HomeScreenState {
  HomeScreenLoaded({
    required this.days,
    this.index = 0,
  });

  final List<Day> days;
  final int index;

  @override
  List<Object> get props => [
        days,
        index,
      ];
}
