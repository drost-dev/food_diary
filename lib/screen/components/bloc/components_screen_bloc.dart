import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary_app/models/component.dart';
import 'package:food_diary_app/repos/database_repo.dart';
import 'package:get_it/get_it.dart';
part 'components_screen_event.dart';
part 'components_screen_state.dart';

class ComponentsScreenBloc
    extends Bloc<ComponentsScreenEvent, ComponentsScreenState> {
  ComponentsScreenBloc() : super(ComponentsScreenLoading()) {
    on<ComponentsScreenEvent>((event, emit) async {
      switch (event) {
        case ComponentsScreenLoad():
          emit(ComponentsScreenLoading());

          DatabaseRepository dbRepo = GetIt.I.get<DatabaseRepository>();
          var components = await dbRepo.getAllComponents();

          emit(ComponentsScreenLoaded(components: components));
          break;
      }
    });
  }
}
