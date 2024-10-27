import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:food_diary_app/router/router.dart';
import 'package:food_diary_app/screen/components/bloc/components_screen_bloc.dart';

class ComponentCard extends StatelessWidget {
  const ComponentCard({
    super.key,
    required this.state,
    required this.index,
  });

  final ComponentsScreenLoaded state;
  final int index;
  int get id => state.components[index].id!;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AutoRouter.of(context)
            .navigate(ComponentRoute(oldComponent: state.components[index]));
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.inversePrimary,
            width: 3,
          ),
        ),
        constraints: const BoxConstraints(minHeight: 50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(state.components[index].name),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: state.components[index].imgPath != 'null'
                        ? Image.file(
                            fit: BoxFit.cover,
                            File(state.components[index].imgPath!),
                          )
                        : const Icon(Icons.fastfood),
                  ),
                ),
              ],
            ),
            const Text(
              "Б / Ж / У / ккал на 100г:",
            ),
            Text(
              "${state.components[index].nutrients.belki} / ${state.components[index].nutrients.jiri} / ${state.components[index].nutrients.ugl} / ${state.components[index].nutrients.calories}",
            ),
          ],
        ),
      ),
    );
  }
}
