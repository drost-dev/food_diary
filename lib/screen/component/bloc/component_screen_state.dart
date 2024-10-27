part of 'component_screen_bloc.dart';

abstract class ComponentScreenState extends Equatable {}

class ComponentScreenLoading extends ComponentScreenState {
  ComponentScreenLoading();

  @override
  List<Object> get props => [];
}

class ComponentScreenLoaded extends ComponentScreenState {
  ComponentScreenLoaded();

  @override
  List<Object> get props => [];
}
