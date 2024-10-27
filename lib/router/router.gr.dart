// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [ComponentScreen]
class ComponentRoute extends PageRouteInfo<ComponentRouteArgs> {
  ComponentRoute({
    Key? key,
    Component? oldComponent,
    List<PageRouteInfo>? children,
  }) : super(
          ComponentRoute.name,
          args: ComponentRouteArgs(
            key: key,
            oldComponent: oldComponent,
          ),
          initialChildren: children,
        );

  static const String name = 'ComponentRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ComponentRouteArgs>(
          orElse: () => const ComponentRouteArgs());
      return ComponentScreen(
        key: args.key,
        oldComponent: args.oldComponent,
      );
    },
  );
}

class ComponentRouteArgs {
  const ComponentRouteArgs({
    this.key,
    this.oldComponent,
  });

  final Key? key;

  final Component? oldComponent;

  @override
  String toString() {
    return 'ComponentRouteArgs{key: $key, oldComponent: $oldComponent}';
  }
}

/// generated route for
/// [ComponentsScreen]
class ComponentsRoute extends PageRouteInfo<void> {
  const ComponentsRoute({List<PageRouteInfo>? children})
      : super(
          ComponentsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ComponentsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ComponentsScreen();
    },
  );
}

/// generated route for
/// [DishScreen]
class DishRoute extends PageRouteInfo<DishRouteArgs> {
  DishRoute({
    Key? key,
    Dish? dish,
    List<PageRouteInfo>? children,
  }) : super(
          DishRoute.name,
          args: DishRouteArgs(
            key: key,
            dish: dish,
          ),
          initialChildren: children,
        );

  static const String name = 'DishRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<DishRouteArgs>(orElse: () => const DishRouteArgs());
      return DishScreen(
        key: args.key,
        dish: args.dish,
      );
    },
  );
}

class DishRouteArgs {
  const DishRouteArgs({
    this.key,
    this.dish,
  });

  final Key? key;

  final Dish? dish;

  @override
  String toString() {
    return 'DishRouteArgs{key: $key, dish: $dish}';
  }
}

/// generated route for
/// [DishesScreen]
class DishesRoute extends PageRouteInfo<void> {
  const DishesRoute({List<PageRouteInfo>? children})
      : super(
          DishesRoute.name,
          initialChildren: children,
        );

  static const String name = 'DishesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DishesScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}
