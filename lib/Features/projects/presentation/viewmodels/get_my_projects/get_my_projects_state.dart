import 'package:equatable/equatable.dart';
import 'package:takween/Features/projects/data/models/project_list_item_model.dart';

abstract class GetMyProjectsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetMyProjectsInitialState extends GetMyProjectsState {}

class GetMyProjectsLoadingState extends GetMyProjectsState {}

class GetMyProjectsSuccessState extends GetMyProjectsState {
  final List<ProjectListItemModel> projects;

  GetMyProjectsSuccessState(this.projects);

  @override
  List<Object?> get props => [projects];
}

class GetMyProjectsFailureState extends GetMyProjectsState {
  final String message;
  GetMyProjectsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
