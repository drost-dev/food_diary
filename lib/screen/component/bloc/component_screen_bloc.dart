import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_diary_app/models/component.dart';
import 'package:food_diary_app/repos/database_repo.dart';
import 'package:get_it/get_it.dart';

part 'component_screen_event.dart';
part 'component_screen_state.dart';

class ComponentScreenBloc
    extends Bloc<ComponentScreenEvent, ComponentScreenState> {
  ComponentScreenBloc() : super(ComponentScreenLoading()) {
    on<ComponentScreenEvent>(
      (event, emit) async {
        switch (event) {
          case ComponentScreenLoad():
            emit(ComponentScreenLoaded());
            break;
          case ComponentScreenEdit():
            DatabaseRepository dbRepo = GetIt.I.get<DatabaseRepository>();
            await dbRepo.addOrUpdateComponent(
              newComponent: event.updatedComponent,
              oldComponent: event.oldComponent,
            );
            break;
          case ComponentScreenDelete():
            DatabaseRepository dbRepo = GetIt.I.get<DatabaseRepository>();
            await dbRepo.deleteComponent(component: event.component);
            break;
        }
      },
    );
  }
}
