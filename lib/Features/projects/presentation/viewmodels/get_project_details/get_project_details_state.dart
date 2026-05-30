import 'package:equatable/equatable.dart';
import 'package:takween/Features/projects/data/models/project_model.dart';

abstract class GetProjectDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProjectDetailsInitialState extends GetProjectDetailsState {}

class GetProjectDetailsLoadingState extends GetProjectDetailsState {}

class GetProjectDetailsSuccessState extends GetProjectDetailsState {
  final ProjectModel project;
  GetProjectDetailsSuccessState(this.project);

  @override
  List<Object?> get props => [project];
}

class GetProjectDetailsFailureState extends GetProjectDetailsState {
  final String message;
  GetProjectDetailsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
