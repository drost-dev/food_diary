import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary_app/models/day.dart';
import 'package:food_diary_app/repos/database_repo.dart';
import 'package:get_it/get_it.dart';
part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc() : super(HomeScreenLoading()) {
    DatabaseRepository dbRepo = GetIt.I.get<DatabaseRepository>();

    on<HomeScreenEvent>((event, emit) async {
      switch (event) {
        case HomeScreenLoad():
          var days = await dbRepo.getAllDays();
          emit(HomeScreenLoaded(
            days: days,
          ));
          break;

        case HomeScreenSwitchPage():
          if (event.newDayId >= 0 && event.newDayId <= 6) {
            event.onSuccess.call();
          }
          break;
      }
    });
  }
}
