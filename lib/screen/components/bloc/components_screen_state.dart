part of 'components_screen_bloc.dart';

abstract class ComponentsScreenState extends Equatable {}

class ComponentsScreenLoading extends ComponentsScreenState {
  ComponentsScreenLoading();

  @override
  List<Object> get props => [];
}

class ComponentsScreenLoaded extends ComponentsScreenState {
  ComponentsScreenLoaded({
    required this.components,
  });

  final List<Component> components;

  @override
  List<Object> get props => [components];
}
