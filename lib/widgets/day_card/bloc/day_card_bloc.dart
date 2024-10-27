import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary_app/models/day.dart';
import 'package:food_diary_app/models/food_card.dart';
import 'package:food_diary_app/repos/database_repo.dart';
import 'package:get_it/get_it.dart';

part 'day_card_event.dart';
part 'day_card_state.dart';

class DayCardBloc extends Bloc<DayCardEvent, DayCardState> {
  DayCardBloc() : super(DayCardLoading()) {
    on<DayCardEvent>((event, emit) async {
      switch (event) {
        case DayCardLoad():
          var dbRepo = GetIt.I<DatabaseRepository>();
          var foodCards = await dbRepo.getFoodCardsForDay(event.day.id);
          emit(DayCardLoaded(foodCards: foodCards));
          break;
        case DayCardAddFoodCard():
          var dbRepo = GetIt.I<DatabaseRepository>();

          var foodCard = FoodCard(name: 'Без имени', dishes: []);
          var foodCardId = await dbRepo.addOrUpdateFoodCard(newFoodCard: foodCard);
          foodCard.id = foodCardId;

          var newDay = event.day;
          newDay.foodCards.add(foodCard);

          await dbRepo.updateDay(
            oldDay: event.day,
            newDay: newDay,
          );

          var foodCards = await dbRepo.getFoodCardsForDay(event.day.id);
          emit(DayCardLoaded(foodCards: foodCards));
          break;
      }
    });
  }
}
