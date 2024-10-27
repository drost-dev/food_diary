import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary_app/models/component.dart';
import 'package:food_diary_app/models/dish.dart';
import 'package:food_diary_app/repos/database_repo.dart';
import 'package:get_it/get_it.dart';

part 'dish_screen_event.dart';
part 'dish_screen_state.dart';

class DishScreenBloc extends Bloc<DishScreenEvent, DishScreenState> {
  DishScreenBloc() : super(DishScreenLoading()) {
    on<DishScreenEvent>(
      (event, emit) async {
        switch (event) {
          case DishScreenLoad():
            DatabaseRepository dbRepo = GetIt.I.get<DatabaseRepository>();
            var compsList = await dbRepo.getAllComponents();

            emit(DishScreenLoaded(components: compsList));
            break;
          case DishScreenAdd():
            DatabaseRepository dbRepo = GetIt.I.get<DatabaseRepository>();
            await dbRepo.addOrUpdateDish(newDish: event.dish);
            break;
        }
      },
    );
  }
}
