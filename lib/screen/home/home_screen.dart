import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary_app/screen/home/bloc/home_screen_bloc.dart';
import 'package:food_diary_app/widgets/day_card/day_card.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenBloc _bloc = HomeScreenBloc();

  int index = 0;

  final pageController = PageController(
    initialPage: 0,
    keepPage: false,
  );

  @override
  void initState() {
    super.initState();
    _bloc.add(HomeScreenLoad());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (context, state) {
        if (state is HomeScreenLoaded) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(state.days[index].name),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {
                  //prev
                  _bloc.add(
                    HomeScreenSwitchPage(
                      newDayId: index - 1,
                      onSuccess: () {
                        setState(() {
                          index -= 1;
                        });
                        pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.fastOutSlowIn,
                        );
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.keyboard_arrow_left_rounded),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    _bloc.add(
                      HomeScreenSwitchPage(
                        newDayId: index + 1,
                        onSuccess: () {
                          setState(() {
                            index += 1;
                          });
                          pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.fastOutSlowIn,
                          );
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.keyboard_arrow_right_rounded),
                ),
              ],
            ),
            body: PageView.builder(
              controller: pageController,
              itemCount: 7,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return DayCard(
                  day: state.days[index],
                );
              },
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
