import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary_app/router/router.dart';
import 'package:food_diary_app/screen/dishes/bloc/dishes_screen_bloc.dart';

@RoutePage()
class DishesScreen extends StatefulWidget {
  const DishesScreen({super.key});

  @override
  State<DishesScreen> createState() => _DishesScreenState();
}

class _DishesScreenState extends State<DishesScreen> {
  final _bloc = DishesScreenBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(DishesScreenLoad());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Блюда'),
        centerTitle: true,
      ),
      body: BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          if (state is DishesScreenLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                _bloc.add(DishesScreenLoad());
              },
              child: Container(
                margin: const EdgeInsets.all(15),
                child: ListView.separated(
                  itemCount: state.dishes.length,
                  itemBuilder: (context, index) {
                    //return Text(state.items[index]['name'].toString());
                    return GestureDetector(
                      onTap: () {
                        AutoRouter.of(context)
                            .navigate(DishRoute(dish: state.dishes[index]));
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
                                Text(state.dishes[index].name),
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
                                            fit: BoxFit.cover,
                                            File(state.dishes[index].imgPath!),
                                          )
                                        : const Icon(Icons.fastfood),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      "Б / Ж / У / ккал:",
                                    ),
                                    Text(
                                      "${state.dishes[index].nutrients.belki.toStringAsFixed(2)} / ${state.dishes[index].nutrients.jiri.toStringAsFixed(2)} / ${state.dishes[index].nutrients.ugl.toStringAsFixed(2)} / ${state.dishes[index].nutrients.calories.toStringAsFixed(2)}",
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    _bloc.add(
                                      DishesScreenDelete(
                                          dish: state.dishes[index]),
                                    );
                                    _bloc.add(DishesScreenLoad());
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 15);
                  },
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AutoRouter.of(context).navigateNamed('/dishes/edit');
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
