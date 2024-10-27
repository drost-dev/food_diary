part of 'day_card_bloc.dart';

abstract class DayCardEvent extends Equatable {}

class DayCardLoad extends DayCardEvent {
  DayCardLoad({
    required this.day,
  });

  final Day day;

  @override
  List<Object> get props => [day];
}

class DayCardAddFoodCard extends DayCardEvent {
  DayCardAddFoodCard({required this.day});

  final Day day;

  @override
  List<Object> get props => [day];
}
