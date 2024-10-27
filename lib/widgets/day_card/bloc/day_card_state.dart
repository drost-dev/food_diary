part of 'day_card_bloc.dart';

abstract class DayCardState extends Equatable {}

class DayCardLoading extends DayCardState {
  DayCardLoading();

  @override
  List<Object> get props => [];
}

class DayCardLoaded extends DayCardState {
  DayCardLoaded({
    required this.foodCards,
  });

  final List<FoodCard> foodCards;

  @override
  List<Object> get props => [foodCards];
}
