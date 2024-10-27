import 'package:flutter/material.dart';
import 'package:food_diary_app/models/component.dart';
import 'package:food_diary_app/screen/dish/bloc/dish_screen_bloc.dart';
import 'package:food_diary_app/widgets/input_textformfield.dart';

class DishCard extends StatelessWidget {
  const DishCard({
    super.key,
    required this.state,
    this.component,
    required this.onChanged,
    this.onSelected,
  });

  final DishScreenLoaded state;
  final Component? component;

  final void Function(String) onChanged;
  final void Function(dynamic)? onSelected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(
        minHeight: 160,
      ),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.inversePrimary,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownMenu(
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            width: double.infinity,
            label: const Text('Выберите компонент'),
            menuHeight: 200,
            onSelected: onSelected,
            initialSelection: component != null ? state.components.where((e) => e.id == component!.id) : state.components[0],
            dropdownMenuEntries:
                List<DropdownMenuEntry>.generate(state.components.length,
                    (index) {
              return DropdownMenuEntry(
                value: state.components[index],
                label: state.components[index].name,
              );
            }),
          ),
          InputTextField(
            onChanged: onChanged,
            label: 'Грамм на порцию',
            numeric: true,
            text: component?.amount.toString(),
          ),
          // TextButton(
          //   onPressed: onPressed,
          //   style: TextButton.styleFrom(
          //     backgroundColor: Colors.red.withOpacity(0.3),
          //   ),
          //   child: Text('Удалить'),
          // )
        ],
      ),
    );
  }
}
