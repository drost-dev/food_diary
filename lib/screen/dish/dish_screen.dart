import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary_app/models/component.dart';
import 'package:food_diary_app/models/dish.dart';
import 'package:food_diary_app/models/nutrients.dart';
import 'package:food_diary_app/screen/dish/bloc/dish_screen_bloc.dart';
import 'package:food_diary_app/widgets/dish_card.dart';
import 'package:food_diary_app/widgets/input_textformfield.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class DishScreen extends StatefulWidget {
  const DishScreen({
    super.key,
    this.dish,
  });
  final Dish? dish;

  @override
  State<DishScreen> createState() => _DishScreenState();
}

class _DishScreenState extends State<DishScreen> {
  final DishScreenBloc _bloc = DishScreenBloc();

  Dish newDish = Dish(nutrients: Nutrients(), components: []);

  @override
  void initState() {
    super.initState();
    _bloc.add(DishScreenLoad());
    newDish = widget.dish ?? Dish(nutrients: Nutrients(), components: []);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Добавление блюда'),
        centerTitle: true,
      ),
      body: BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          if (state is DishScreenLoaded) {
            return Container(
              margin: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InputTextField(
                        onChanged: (value) {
                          setState(() {
                            newDish.name = value;
                          });
                        },
                        label: 'Название',
                        text: widget.dish?.name ?? 'Без названия',
                      ),
                      Container(
                        constraints: const BoxConstraints(
                          maxHeight: 286,
                        ),
                        child: ListView.separated(
                          itemBuilder: (context, index) {
                            return DishCard(
                              state: state,
                              component: widget.dish?.components[index],
                              onChanged: (value) {
                                newDish.components[index].amount =
                                    double.tryParse(value) ?? 0;
                                setState(() {
                                  newDish.nutrients =
                                      _getTotalNutrients(newDish.components);
                                });
                              },
                              onSelected: (value) {
                                newDish.components[index] = value;
                                setState(() {
                                  newDish.nutrients =
                                      _getTotalNutrients(newDish.components);
                                });
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              height: 15,
                            );
                          },
                          itemCount: newDish.components.length,
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                newDish.components
                                    .add(Component(nutrients: Nutrients()));
                                newDish.nutrients =
                                    _getTotalNutrients(newDish.components);
                              });
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.delete_outline_rounded),
                                SizedBox(width: 5),
                                Text('Добавить компонент'),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              AutoRouter.of(context).pushNamed('/components');
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit),
                                SizedBox(width: 5),
                                Text('Компоненты'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // IconButton.filled(
                      //   style: IconButton.styleFrom(
                      //     backgroundColor: theme.colorScheme.inversePrimary,
                      //   ),
                      //   color: Colors.black,
                      //   onPressed: () {

                      //   },
                      //   tooltip: "Добавить блюдо",
                      //   icon: const Icon(Icons.add),
                      // ),
                    ],
                  ),

                  Text(
                    "Б / Ж / У / ккал:\n${newDish.nutrients.belki.toStringAsFixed(2)}, ${newDish.nutrients.jiri.toStringAsFixed(2)}, ${newDish.nutrients.ugl.toStringAsFixed(2)}, ${newDish.nutrients.calories.toStringAsFixed(2)}",
                    textAlign: TextAlign.center,
                  ),

                  //картинка
                  GestureDetector(
                    onTap: () {
                      _selectPhoto();
                    },
                    child: Container(
                      width: 230,
                      height: 230,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child:
                          newDish.imgPath != null && newDish.imgPath != 'null'
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.file(
                                    File(newDish.imgPath!),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.image_outlined,
                                        size: 100,
                                      ),
                                      Text(
                                        'Нажмите сюда, чтобы выбрать изображение',
                                        textAlign: TextAlign.center,
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (newDish.components.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Состав блюда не может быть пустым!'),
              ),
            );
            return;
          }

          _bloc.add(
            DishScreenAdd(dish: newDish),
          );

          AutoRouter.of(context).maybePop();
        },
        child: const Icon(Icons.save_outlined),
      ),
    );
  }

  void _selectPhoto() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img == null) return;
    setState(() {
      newDish.imgPath = img.path;
    });
  }

  Nutrients _getTotalNutrients(List<Component> components) {
    Nutrients result = Nutrients();

    for (int i = 0; i < components.length; i++) {
      result.belki +=
          components[i].amount / 100 * components[i].nutrients.belki;
      result.jiri += components[i].amount / 100 * components[i].nutrients.jiri;
      result.ugl += components[i].amount / 100 * components[i].nutrients.ugl;
      result.calories +=
          components[i].amount / 100 * components[i].nutrients.calories;
    }

    return result;
  }
}
