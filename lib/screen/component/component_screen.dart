import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary_app/models/component.dart';
import 'package:food_diary_app/models/nutrients.dart';
import 'package:food_diary_app/screen/component/bloc/component_screen_bloc.dart';
import 'package:food_diary_app/widgets/input_textformfield.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class ComponentScreen extends StatefulWidget {
  const ComponentScreen({super.key, this.oldComponent});
  final Component? oldComponent;

  @override
  State<ComponentScreen> createState() => _ComponentScreenState();
}

class _ComponentScreenState extends State<ComponentScreen> {
  final ComponentScreenBloc _bloc = ComponentScreenBloc();

  late Component currentComponent = widget.oldComponent ?? Component(nutrients: Nutrients());

  @override
  void initState() {
    super.initState();
    _bloc.add(ComponentScreenLoad());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // if (_isFirstLoad) {
    //   currentComponent = widget.oldComponent ?? Component(nutrients: Nutrients());
    //   _isFirstLoad = !_isFirstLoad;
    // }

    return BlocBuilder(
      bloc: _bloc,
      builder: (context, state) {
        if (state is ComponentScreenLoaded) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text('Редактирование'),
              centerTitle: true,
              actions: currentComponent.id != null
                  ? [
                      IconButton(
                        onPressed: () {
                          _bloc.add(ComponentScreenDelete(
                              component: currentComponent));
                          AutoRouter.of(context).maybePop();
                        },
                        icon: const Icon(Icons.delete_outline_rounded),
                      ),
                    ]
                  : null,
            ),
            body: Container(
              margin: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 356,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InputTextField(
                          onChanged: (value) {
                            setState(() {
                              currentComponent.name = value;
                            });
                          },
                          label: 'Название',
                          text: currentComponent.name,
                        ),
                        InputTextField(
                          onChanged: (value) {
                            setState(() {
                              currentComponent.nutrients.calories =
                                  double.tryParse(value) ?? 0;
                            });
                          },
                          label: 'Ккал на 100г',
                          text: currentComponent.nutrients.calories
                              .toString(),
                          numeric: true,
                        ),
                        InputTextField(
                          onChanged: (value) {
                            setState(() {
                              currentComponent.nutrients.belki =
                                  double.tryParse(value) ?? 0;
                            });
                          },
                          label: 'Белков на 100г',
                          text: currentComponent.nutrients.belki
                              .toString(),
                          numeric: true,
                        ),
                        InputTextField(
                          onChanged: (value) {
                            setState(() {
                              currentComponent.nutrients.jiri =
                                  double.tryParse(value) ?? 0;
                            });
                          },
                          label: 'Жиров на 100г',
                          text:
                              currentComponent.nutrients.jiri.toString(),
                          numeric: true,
                        ),
                        InputTextField(
                          onChanged: (value) {
                            setState(() {
                              currentComponent.nutrients.ugl =
                                  double.tryParse(value) ?? 0;
                            });
                          },
                          label: 'Углеводов на 100г',
                          text:
                              currentComponent.nutrients.ugl.toString(),
                          numeric: true,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      _selectPhoto();
                    },
                    child: Container(
                      width: 230,
                      height: 230,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: currentComponent.imgPath != null &&
                              currentComponent.imgPath != 'null'
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                File(currentComponent.imgPath!),
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
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _bloc.add(
                  ComponentScreenEdit(
                      updatedComponent: currentComponent,
                      oldComponent: widget.oldComponent),
                );
                AutoRouter.of(context).maybePop();
              },
              child: const Icon(Icons.save_outlined),
            ),
          );

          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   if (_isLoaded) return;
          //   setState(() {
          //     if (state.currentComponent != null) {
          //       oldComponent = state.currentComponent!;
          //       currentComponent.name = oldComponent.name;
          //       currentComponent.nutrients.calories =
          //           oldComponent.nutrients.calories;
          //       currentComponent.nutrients.belki = oldComponent.nutrients.belki;
          //       currentComponent.nutrients.jiri = oldComponent.nutrients.jiri;
          //       currentComponent.nutrients.ugl = oldComponent.nutrients.ugl;
          //       currentComponent.img = oldComponent.img;
          //     }
          //     _isLoaded = !_isLoaded;
          //   });
          // });
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _selectPhoto() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img == null) return;
    setState(() {
      currentComponent.imgPath = img.path;
    });
  }
}
