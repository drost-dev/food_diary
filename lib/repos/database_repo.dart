import 'dart:async';
import 'package:food_diary_app/models/component.dart';
import 'package:food_diary_app/models/day.dart';
import 'package:food_diary_app/models/dish.dart';
import 'package:food_diary_app/models/food_card.dart';
import 'package:food_diary_app/models/nutrients.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseRepository {
  DatabaseRepository._init(this.db);

  static Future<DatabaseRepository> init() async {
    Database db = await openDatabase(
      'test10.db',
      version: 1,
      onOpen: _onDatabaseOpen,
    );

    DatabaseRepository dbRepo = DatabaseRepository._init(db);

    return dbRepo;
  }

  late Database db;

  static FutureOr<void> _onDatabaseOpen(Database db) async {
    await db.execute(
      """
      create table if not exists days(
      id integer primary key, 
      name varchar(2)
      );
      """,
    );
    var count = await db.rawQuery(
      """select * from days""",
    );
    if (count.length != 7) {
      await db.rawInsert(
        """
        insert into days(id, name) values 
        (0, 'ПН'), 
        (1, 'ВТ'), 
        (2, 'СР'), 
        (3, 'ЧТ'), 
        (4, 'ПТ'), 
        (5, 'СБ'), 
        (6, 'ВС');
        """,
      );
    }

    await db.execute(
      """
      create table if not exists food_cards(
      id integer primary key autoincrement,
      name varchar(256),
      photo_path varchar(512)
      );
      """,
    );

    await db.execute(
      """
      create table if not exists day_food_cards(
      day_id integer references days,
      food_card_id integer references food_cards
      );
      """,
    );

    await db.execute(
      """
      create table if not exists dishes(
      id integer primary key autoincrement, 
      name varchar(128), 
      calories real,
      belki real,
      jiri real,
      ugl real,
      photo_path varchar(512)
      );
      """,
    );

    await db.execute(
      """
      create table if not exists food_card_dishes(
      food_card_id integer references food_cards,
      dish_id integer references dishes
      );
      """,
    );

    await db.execute(
      """
      create table if not exists components(
      id integer primary key autoincrement, 
      name varchar(128), 
      calories real,
      belki real,
      jiri real,
      ugl real,
      photo_path varchar(512)
      );
      """,
    );

    await db.execute(
      """
      create table if not exists dish_components(
      dish_id integer references dishes,
      component_id integer references components,
      amount real 
      );
      """,
    );
  }

  //components
  Future<Component> getComponentById(int compId) async {
    var compQuery = await db.rawQuery(
      """select * from components where id = $compId""",
    );

    Component comp = Component(
      id: int.parse(compQuery[0]['id'].toString()),
      name: compQuery[0]['name'].toString(),
      nutrients: Nutrients(
        belki: double.parse(compQuery[0]['belki'].toString()),
        jiri: double.parse(compQuery[0]['jiri'].toString()),
        ugl: double.parse(compQuery[0]['ugl'].toString()),
        calories: double.parse(compQuery[0]['calories'].toString()),
      ),
      imgPath: compQuery[0]['photo_path'].toString(),
      amount: double.tryParse(compQuery[0]['amount'].toString()) ?? 0,
    );

    return comp;
  }

  Future<List<Component>> getAllComponents() async {
    var compsQuery = await db.rawQuery(
      """select id from components""",
    );

    List<Component> comps = [];

    for (int i = 0; i < compsQuery.length; i++) {
      Component comp = await getComponentById(
        int.parse(compsQuery[i]['id'].toString()),
      );

      comps.add(comp);
    }

    return comps;
  }

  Future<void> addOrUpdateComponent({
    required Component newComponent,
    Component? oldComponent,
  }) async {
    if (oldComponent != null) {
      //изменение
      await db.rawUpdate(
        """update components
            set name = '${newComponent.name}',
            calories = '${newComponent.nutrients.calories}',
            belki = '${newComponent.nutrients.belki}',
            jiri = '${newComponent.nutrients.jiri}', 
            ugl = '${newComponent.nutrients.ugl}', 
            photo_path = '${newComponent.imgPath}'
            where id = ${oldComponent.id}""",
      );
    } else {
      //добавление
      await db.rawInsert(
        """insert into components(name, calories, belki, jiri, ugl, photo_path)
          values ('${newComponent.name}', ${newComponent.nutrients.calories}, ${newComponent.nutrients.belki}, ${newComponent.nutrients.jiri}, ${newComponent.nutrients.ugl}, '${newComponent.imgPath}');""",
      );
    }
  }

  Future<void> deleteComponent({required Component component}) async {
    await db.rawDelete(
      """delete from components where id = ${component.id}""",
    );

    await db.rawDelete(
      """delete from dish_components where component_id = ${component.id}""",
    );
  }

  Future<List<Component>> getComponentsForDish(int dishId) async {
    var dishQuery = await db.rawQuery(
      """select component_id from dish_components where dish_id = $dishId""",
    );

    List<Component> comps = [];

    for (int i = 0; i < dishQuery.length; i++) {
      comps.add(
        await getComponentById(
          int.parse(
            dishQuery[i]['component_id'].toString(),
          ),
        ),
      );
    }

    return comps;
  }

  //dishes
  Future<Dish> getDishById(int dishId) async {
    var dishQuery = await db.rawQuery(
      """select * from dishes where id = $dishId""",
    );

    var comps = await getComponentsForDish(dishId);

    Dish dish = Dish(
      id: int.parse(dishQuery[0]['id'].toString()),
      name: dishQuery[0]['name'].toString(),
      nutrients: Nutrients(
        belki: double.parse(dishQuery[0]['belki'].toString()),
        jiri: double.parse(dishQuery[0]['jiri'].toString()),
        ugl: double.parse(dishQuery[0]['ugl'].toString()),
        calories: double.parse(dishQuery[0]['calories'].toString()),
      ),
      components: comps,
      imgPath: dishQuery[0]['photo_path'].toString(),
    );

    return dish;
  }

  Future<List<Dish>> getAllDishes() async {
    var dishesQuery = await db.rawQuery(
      """select id from dishes""",
    );

    List<Dish> dishes = [];

    for (int i = 0; i < dishesQuery.length; i++) {
      Dish dish = await getDishById(
        int.parse(
          dishesQuery[i]['id'].toString(),
        ),
      );

      dishes.add(dish);
    }

    return dishes;
  }

  Future<void> addOrUpdateDish({
    required Dish newDish,
    int? foodCardId,
    Dish? oldDish,
  }) async {
    if (oldDish == null) {
      var dishIdQuery = await db.rawInsert(
        """
        insert into dishes(name, calories, belki, jiri, ugl, photo_path) 
        values ('${newDish.name}', ${newDish.nutrients.calories}, ${newDish.nutrients.belki}, ${newDish.nutrients.jiri}, ${newDish.nutrients.ugl}, '${newDish.imgPath}');
        """,
      );

      if (foodCardId != null) {
        await db.rawInsert(
          """
        insert into food_card_dishes(food_card_id, dish_id) 
        values ('$foodCardId', '${newDish.id ?? dishIdQuery}');
        """,
        );
      }

      for (int i = 0; i < newDish.components.length; i++) {
        await db.rawInsert(
          """
          insert into dish_components(dish_id, component_id, amount)
          values ($dishIdQuery, ${newDish.components[i].id}, ${newDish.components[i].amount});
          """,
        );
      }
    } else {
      await db.rawInsert(
        """
        update dishes
        set name = '${newDish.name}',
        calories = ${newDish.nutrients.calories},
        belki = ${newDish.nutrients.belki},
        jiri = ${newDish.nutrients.jiri},
        ugl = ${newDish.nutrients.ugl},
        photo_path = '${newDish.imgPath}'
        where id = ${oldDish.id};
        """,
      );

      await db.rawDelete(
        """
        delete from dish_components
        where dish_id = ${oldDish.id};
        """,
      );

      for (int i = 0; i < newDish.components.length; i++) {
        await db.rawInsert(
          """
          insert into dish_components(dish_id, component_id, amount)
          values (${oldDish.id}, ${newDish.components[i].id}, ${newDish.components[i].amount});
          """,
        );
      }
    }
  }

  Future<void> deleteDish({required Dish dish}) async {
    await db.rawDelete(
      """delete from dishes where id = ${dish.id}""",
    );

    await db.rawDelete(
      """delete from dish_components where dish_id = ${dish.id}""",
    );

    await db.rawDelete(
      """delete from food_card_dishes where dish_id = ${dish.id}""",
    );
  }

  Future<List<Dish>> getDishesForFoodCard(int foodCardId) async {
    var dishesQuery = await db.rawQuery(
      """select dish_id from food_card_dishes where food_card_id = $foodCardId""",
    );

    List<Dish> dishes = [];

    for (int i = 0; i < dishesQuery.length; i++) {
      Dish dish = await getDishById(
        int.parse(
          dishesQuery[i]['dish_id'].toString(),
        ),
      );

      dishes.add(dish);
    }

    return dishes;
  }

  //foodCards
  Future<FoodCard> getFoodCardById(int foodCardId) async {
    var foodCardQuery = await db.rawQuery(
      """select * from food_cards where id = $foodCardId""",
    );

    var dishes = await getDishesForFoodCard(foodCardId);

    FoodCard foodCard = FoodCard(
      id: int.parse(foodCardQuery[0]['id'].toString()),
      name: foodCardQuery[0]['name'].toString(),
      dishes: dishes,
      imgPath: foodCardQuery[0]['photo_path'].toString(),
    );
    return foodCard;
  }

  Future<List<FoodCard>> getAllFoodCards() async {
    var foodCardsQuery = await db.rawQuery(
      """select id from food_cards""",
    );

    List<FoodCard> foodCards = [];

    for (int i = 0; i < foodCardsQuery.length; i++) {
      FoodCard foodCard = await getFoodCardById(
        int.parse(
          foodCardsQuery[i]['id'].toString(),
        ),
      );

      foodCards.add(foodCard);
    }

    return foodCards;
  }

  Future<int> addOrUpdateFoodCard({
    required FoodCard newFoodCard,
    //required int dayId,
    FoodCard? oldFoodCard,
  }) async {
    if (oldFoodCard == null) {
      var foodCardIdQuery = await db.rawInsert(
        """
        insert into food_cards(name, photo_path) 
        values ('${newFoodCard.name}', '${newFoodCard.imgPath}');
        """,
      );

      // await db.rawInsert(
      //   """
      //   insert into day_food_cards(day_id, food_card_id)
      //   values ('${dayId}', '${newFoodCard.id ?? foodCardIdQuery}');
      //   """,
      // );

      for (int i = 0; i < newFoodCard.dishes.length; i++) {
        await db.rawInsert(
          """
          insert into food_card_dishes(food_card_id, dish_id)
          values ($foodCardIdQuery, ${newFoodCard.dishes[i].id});
          """,
        );
      }

      return foodCardIdQuery;
    } else {
      await db.rawInsert(
        """
        update food_cards
        set name = '${newFoodCard.name}',
        photo_path = '${newFoodCard.imgPath}'
        where id = ${oldFoodCard.id};
        """,
      );

      await db.rawDelete(
        """
        delete from food_card_dishes
        where food_card_id = ${oldFoodCard.id};
        """,
      );

      for (int i = 0; i < newFoodCard.dishes.length; i++) {
        await db.rawInsert(
          """
          insert into food_card_dishes(food_card_id, dish_id)
          values (${oldFoodCard.id}, ${newFoodCard.dishes[i].id});
          """,
        );
      }

      return oldFoodCard.id!;
    }
  }

  Future<void> deleteFoodCard({required FoodCard foodCard}) async {
    await db.rawDelete(
      """delete from food_cards where id = ${foodCard.id}""",
    );

    await db.rawDelete(
      """delete from day_food_cards where food_card_id = ${foodCard.id}""",
    );

    await db.rawDelete(
      """delete from food_card_dishes where food_card_id = ${foodCard.id}""",
    );
  }

  Future<List<FoodCard>> getFoodCardsForDay(int dayId) async {
    var foodCardsQuery = await db.rawQuery(
      """select food_card_id from day_food_cards where day_id = $dayId""",
    );

    List<FoodCard> foodCards = [];

    for (int i = 0; i < foodCardsQuery.length; i++) {
      FoodCard foodCard = await getFoodCardById(
        int.tryParse(
              foodCardsQuery[i]['food_card_id'].toString(),
            ) ??
            -1,
      );

      foodCards.add(foodCard);
    }

    return foodCards;
  }

  //days
  Future<Day> getDayById(int dayId) async {
    var dayQuery = await db.rawQuery(
      """select * from days where id = $dayId""",
    );

    var foodCards = await getFoodCardsForDay(dayId);

    Day day = Day(
        id: int.parse(dayQuery[0]['id'].toString()),
        name: dayQuery[0]['name'].toString(),
        foodCards: foodCards);

    return day;
  }

  Future<List<Day>> getAllDays() async {
    var daysQuery = await db.rawQuery(
      """select id from days""",
    );

    List<Day> days = [];

    for (int i = 0; i < daysQuery.length; i++) {
      Day day = await getDayById(
        int.parse(
          daysQuery[i]['id'].toString(),
        ),
      );

      days.add(day);
    }

    return days;
  }

  Future<void> updateDay({
    required Day newDay,
    required Day oldDay,
  }) async {
    await db.rawDelete(
      """
        delete from day_food_cards
        where day_id = ${oldDay.id};
        """,
    );

    for (int i = 0; i < newDay.foodCards.length; i++) {
      await db.rawInsert(
        """
          insert into day_food_cards(day_id, food_card_id)
          values (${oldDay.id}, ${newDay.foodCards[i].id});
          """,
      );
    }
  }
}
