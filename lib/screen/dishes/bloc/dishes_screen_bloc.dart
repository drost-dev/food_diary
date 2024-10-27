import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary_app/models/dish.dart';
import 'package:food_diary_app/repos/database_repo.dart';
import 'package:get_it/get_it.dart';

part 'dishes_screen_event.dart';
part 'dishes_screen_state.dart';

class DishesScreenBloc extends Bloc<DishesScreenEvent, DishesScreenState> {
  DishesScreenBloc() : super(DishesScreenLoading()) {
    on<DishesScreenEvent>((event, emit) async {
      switch (event) {
        case DishesScreenLoad():
          emit(DishesScreenLoading());

          DatabaseRepository dbRepo = GetIt.I.get<DatabaseRepository>();
          var dishes = await dbRepo.getAllDishes();

          emit(DishesScreenLoaded(dishes: dishes));
          break;
        case DishesScreenDelete():
          DatabaseRepository dbRepo = GetIt.I.get<DatabaseRepository>();
          await dbRepo.deleteDish(dish: event.dish);
          break;
      }
    });
  }
}
