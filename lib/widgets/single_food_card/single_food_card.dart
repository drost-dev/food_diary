import 'dart:developer';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary_app/models/dish.dart';
import 'package:food_diary_app/models/food_card.dart';
import 'package:food_diary_app/models/nutrients.dart';
import 'package:food_diary_app/widgets/single_food_card/bloc/single_food_card_bloc.dart';

class SingleFoodCard extends StatefulWidget {
  const SingleFoodCard({
    super.key,
    required this.foodCard,
  });

  final FoodCard foodCard;

  @override
  State<SingleFoodCard> createState() => _SingleFoodCardState();
}

class _SingleFoodCardState extends State<SingleFoodCard> {
  final _bloc = SingleFoodCardBloc();
  Nutrients nutrients = Nutrients();

  @override
  void initState() {
    super.initState();
    _bloc.add(SingleFoodCardLoad(foodCard: widget.foodCard));
    setState(() {
      nutrients = _countBJUC(widget.foodCard.dishes);
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return BlocBuilder(
      bloc: _bloc,
      builder: (context, state) {
        if (state is SingleFoodCardLoaded) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.colorScheme.inversePrimary,
                width: 3,
              ),
            ),
            padding: const EdgeInsets.only(bottom: 15),
            child: Column(
              children: [
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 150,
                  ),
                  margin: const EdgeInsets.only(
                    top: 15,
                    right: 15,
                    left: 15,
                  ),
                  child: ListView.separated(
                    itemCount: state.dishes.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            width: 3,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                DropdownMenu(
                                  inputDecorationTheme: InputDecorationTheme(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  width: 180,
                                  label: const Text('Выберите блюдо'),
                                  //menuHeight: 200,
                                  onSelected: (value) {
                                    var newFoodCard = widget.foodCard;
                                    newFoodCard.dishes[index] = value;
                                    _bloc.add(SingleFoodCardUpdate(
                                      oldFoodCard: widget.foodCard,
                                      newFoodCard: newFoodCard,
                                    ));
                                    _bloc.add(SingleFoodCardLoad(
                                      foodCard: widget.foodCard,
                                    ));
                                    setState(() {
                                      nutrients = _countBJUC(state.dishes);
                                    });
                                  },
                                  initialSelection: state.allDishes.firstWhere(
                                      (e) => e.id == state.dishes[index].id),
                                  dropdownMenuEntries:
                                      List<DropdownMenuEntry>.generate(
                                    state.allDishes.length,
                                    (index) {
                                      return DropdownMenuEntry(
                                        value: state.allDishes[index],
                                        label: state.allDishes[index].name,
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: state.dishes[index].imgPath !=
                                                null &&
                                            state.dishes[index].imgPath !=
                                                'null'
                                        ? Image.file(
                                            File(state.dishes[index].imgPath!))
                                        : const Icon(Icons.fastfood_rounded),
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                try {
                                  var oldFoodCard = widget.foodCard
                                    ..dishes = state.dishes;

                                  var newFoodCard = oldFoodCard
                                    ..dishes.remove(oldFoodCard.dishes[index]);

                                  _bloc.add(SingleFoodCardUpdate(
                                    oldFoodCard: oldFoodCard,
                                    newFoodCard: newFoodCard,
                                  ));
                                  _bloc.add(
                                    SingleFoodCardLoad(
                                        foodCard: widget.foodCard),
                                  );
                                } catch (e) {
                                  log(e.toString());
                                }
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Удалить блюдо',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 15,
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        _bloc.add(
                          SingleFoodCardAddDish(foodCard: widget.foodCard),
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add),
                          SizedBox(width: 5),
                          Text('Добавить блюдо'),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        AutoRouter.of(context).pushNamed('/dishes');
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 5),
                          Text('Блюда'),
                        ],
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    try {
                      _bloc.add(SingleFoodCardDelete(
                        foodCard: widget.foodCard,
                      ));
                    } catch (e) {
                      log(e.toString());
                    }
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Удалить приём пищи',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Б / Ж / У / ккал:\n${nutrients.belki} / ${nutrients.jiri} / ${nutrients.ugl} / ${nutrients.calories}',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else {
          return const SizedBox(
            width: 1,
            height: 1,
          );
        }
      },
    );
  }

  Nutrients _countBJUC(List<Dish> dishes) {
    Nutrients res = Nutrients();
    for (int i = 0; i < dishes.length; i++) {
      res.belki += dishes[i].nutrients.belki;
      res.jiri += dishes[i].nutrients.jiri;
      res.ugl += dishes[i].nutrients.ugl;
      res.calories += dishes[i].nutrients.calories;
    }

    res.belki = double.parse(res.belki.toStringAsFixed(2));
    res.jiri = double.parse(res.jiri.toStringAsFixed(2));
    res.ugl = double.parse(res.ugl.toStringAsFixed(2));
    res.calories = double.parse(res.calories.toStringAsFixed(2));

    return res;
  }
}
