part of 'component_screen_bloc.dart';

abstract class ComponentScreenEvent extends Equatable {}

class ComponentScreenLoad extends ComponentScreenEvent {
  ComponentScreenLoad({
    this.oldComponent,
  });

  final Component? oldComponent;

  @override
  List<Object> get props => [];
}

class ComponentScreenEdit extends ComponentScreenEvent {
  ComponentScreenEdit({
    required this.updatedComponent,
    this.oldComponent,
  });

  final Component updatedComponent;

  final Component? oldComponent;

  @override
  List<Object> get props => [
        updatedComponent,
      ];
}

class ComponentScreenDelete extends ComponentScreenEvent {
  ComponentScreenDelete({
    required this.component,
  });

  final Component component;

  @override
  List<Object> get props => [component];
}
