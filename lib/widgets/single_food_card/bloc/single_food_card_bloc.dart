import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary_app/models/dish.dart';
import 'package:food_diary_app/models/food_card.dart';
import 'package:food_diary_app/repos/database_repo.dart';
import 'package:get_it/get_it.dart';

part 'single_food_card_event.dart';
part 'single_food_card_state.dart';

class SingleFoodCardBloc
    extends Bloc<SingleFoodCardEvent, SingleFoodCardState> {
  SingleFoodCardBloc() : super(SingleFoodCardLoading()) {
    on<SingleFoodCardEvent>((event, emit) async {
      switch (event) {
        case SingleFoodCardLoad():
          var dbRepo = GetIt.I<DatabaseRepository>();
          var allDishes = await dbRepo.getAllDishes();
          var dishes = await dbRepo.getDishesForFoodCard(event.foodCard.id!);
          emit(SingleFoodCardLoaded(
            dishes: dishes,
            allDishes: allDishes,
          ));
          break;

        case SingleFoodCardAddDish():
          var dbRepo = GetIt.I<DatabaseRepository>();

          var allDishes = await dbRepo.getAllDishes();

          if (allDishes.isEmpty) {
            var dishes = await dbRepo.getDishesForFoodCard(event.foodCard.id!);
            emit(SingleFoodCardLoaded(
              dishes: dishes,
              allDishes: allDishes,
            ));
            break;
          }

          var defDish = allDishes[0];

          var newFoodCard = event.foodCard;
          newFoodCard.dishes.add(defDish);

          await dbRepo.addOrUpdateFoodCard(
            oldFoodCard: event.foodCard,
            newFoodCard: newFoodCard,
          );
          var dishes = await dbRepo.getDishesForFoodCard(event.foodCard.id!);
          emit(SingleFoodCardLoaded(
            dishes: dishes,
            allDishes: allDishes,
          ));
          break;

        case SingleFoodCardUpdate():
          var dbRepo = GetIt.I<DatabaseRepository>();
          await dbRepo.addOrUpdateFoodCard(
            newFoodCard: event.newFoodCard,
            oldFoodCard: event.oldFoodCard,
          );
          break;

        case SingleFoodCardDelete():
          var dbRepo = GetIt.I<DatabaseRepository>();
          await dbRepo.deleteFoodCard(foodCard: event.foodCard);
          break;
      }
    });
  }
}
