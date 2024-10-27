part of 'components_screen_bloc.dart';

abstract class ComponentsScreenEvent extends Equatable {}

class ComponentsScreenLoad extends ComponentsScreenEvent {
  ComponentsScreenLoad();

  @override
  List<Object> get props => [];
}

class ComponentsScreenSwitchPage extends ComponentsScreenEvent {
  ComponentsScreenSwitchPage();

  @override
  List<Object> get props => [];
}
