import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/projects/data/repos/project_repo.dart';
import 'package:takween/Features/projects/presentation/viewmodels/get_project_details/get_project_details_state.dart';

class GetProjectDetailsCubit extends Cubit<GetProjectDetailsState> {
  final ProjectRepo repo;

  GetProjectDetailsCubit(this.repo) : super(GetProjectDetailsInitialState());

  Future<void> load(String projectId) async {
    emit(GetProjectDetailsLoadingState());
    final result = await repo.getProjectById(projectId);
    result.fold(
      (failure) => emit(GetProjectDetailsFailureState(failure.errMessage)),
      (project) => emit(GetProjectDetailsSuccessState(project)),
    );
  }

  Future<void> refresh(String projectId) => load(projectId);
}
