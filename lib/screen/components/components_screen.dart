import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary_app/screen/components/bloc/components_screen_bloc.dart';
import 'package:food_diary_app/widgets/component_card.dart';

@RoutePage()
class ComponentsScreen extends StatefulWidget {
  const ComponentsScreen({super.key});

  @override
  State<ComponentsScreen> createState() => _ComponentsScreenState();
}

class _ComponentsScreenState extends State<ComponentsScreen> {
  final ComponentsScreenBloc _bloc = ComponentsScreenBloc();

  final pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    _bloc.add(ComponentsScreenLoad());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Простые компоненты'),
        centerTitle: true,
      ),
      body: BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          if (state is ComponentsScreenLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                _bloc.add(ComponentsScreenLoad());
              },
              child: Container(
                margin: const EdgeInsets.all(15),
                child: ListView.separated(
                  itemCount: state.components.length,
                  itemBuilder: (context, index) {
                    return ComponentCard(
                      state: state,
                      index: index,
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
          AutoRouter.of(context).navigateNamed('/components/edit');
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
