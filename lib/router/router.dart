import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:food_diary_app/models/component.dart';
import 'package:food_diary_app/models/dish.dart';
import 'package:food_diary_app/screen/component/component_screen.dart';
import 'package:food_diary_app/screen/components/components_screen.dart';
import 'package:food_diary_app/screen/dish/dish_screen.dart';
import 'package:food_diary_app/screen/dishes/dishes_screen.dart';
import 'package:food_diary_app/screen/home/home_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class $AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: HomeRoute.page,
          path: '/home',
          initial: true,
        ),
        AutoRoute(
          page: ComponentsRoute.page,
          path: '/components',
          //initial: true,
        ),
        AutoRoute(
          page: ComponentRoute.page,
          path: '/components/edit',
        ),
        AutoRoute(
          page: DishesRoute.page,
          path: '/dishes',
          //initial: true,
        ),
        AutoRoute(
          page: DishRoute.page,
          path: '/dishes/edit',
        ),
      ];
}
