import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary_app/models/day.dart';
import 'package:food_diary_app/models/food_card.dart';
import 'package:food_diary_app/models/nutrients.dart';
import 'package:food_diary_app/widgets/day_card/bloc/day_card_bloc.dart';
import 'package:food_diary_app/widgets/single_food_card/single_food_card.dart';

class DayCard extends StatefulWidget {
  const DayCard({
    super.key,
    required this.day,
  });

  final Day day;

  @override
  State<DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<DayCard> {
  final _bloc = DayCardBloc();
  Nutrients nutrients = Nutrients();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.add(DayCardLoad(day: widget.day));
    setState(() {
      nutrients = _countBJUC(widget.day.foodCards);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (context, state) {
        if (state is DayCardLoaded) {
          return Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).colorScheme.inversePrimary,
                width: 3,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.foodCards.length,
                    itemBuilder: (context, index) {
                      return SingleFoodCard(
                        foodCard: state.foodCards[index],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 15,
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _bloc.add(DayCardAddFoodCard(day: widget.day));
                    setState(() {
                      nutrients = _countBJUC(state.foodCards);
                    });
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 5),
                      Text('Добавить приём пищи'),
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

  Nutrients _countBJUC(List<FoodCard> foodCards) {
    Nutrients res = Nutrients();

    for (int i = 0; i < foodCards.length; i++) {
      Nutrients tempRes = Nutrients();

      for (int j = 0; j < foodCards[i].dishes.length; j++) {
        tempRes.belki += foodCards[i].dishes[j].nutrients.belki;
        tempRes.jiri += foodCards[i].dishes[j].nutrients.jiri;
        tempRes.ugl += foodCards[i].dishes[j].nutrients.ugl;
        tempRes.calories += foodCards[i].dishes[j].nutrients.calories;
      }

      res.belki += double.parse(tempRes.belki.toStringAsFixed(2));
      res.jiri += double.parse(tempRes.jiri.toStringAsFixed(2));
      res.ugl += double.parse(tempRes.ugl.toStringAsFixed(2));
      res.calories += double.parse(tempRes.calories.toStringAsFixed(2));
    }

    return res;
  }
}
