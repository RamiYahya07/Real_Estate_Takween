import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/projects/data/repos/project_repo.dart';
import 'package:takween/Features/projects/presentation/viewmodels/get_my_projects/get_my_projects_state.dart';

class GetMyProjectsCubit extends Cubit<GetMyProjectsState> {
  final ProjectRepo repo;

  GetMyProjectsCubit(this.repo) : super(GetMyProjectsInitialState());

  Future<void> load() async {
    emit(GetMyProjectsLoadingState());
    final result = await repo.getMyProjects();
    result.fold(
      (failure) => emit(GetMyProjectsFailureState(failure.errMessage)),
      (projects) => emit(GetMyProjectsSuccessState(projects)),
    );
  }

  Future<void> refresh() => load();
}
