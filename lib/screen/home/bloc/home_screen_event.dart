part of 'home_screen_bloc.dart';

abstract class HomeScreenEvent extends Equatable {}

class HomeScreenLoad extends HomeScreenEvent {
  HomeScreenLoad();

  @override
  List<Object> get props => [];
}

class HomeScreenSwitchPage extends HomeScreenEvent {
  HomeScreenSwitchPage({
    required this.newDayId,
    required this.onSuccess,
  });

  final int newDayId;
  final void Function() onSuccess;

  @override
  List<Object> get props => [
        newDayId,
        onSuccess,
      ];
}
