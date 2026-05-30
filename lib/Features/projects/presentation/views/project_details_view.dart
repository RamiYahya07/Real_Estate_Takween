import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/projects/presentation/viewmodels/get_project_details/get_project_details_cubit.dart';
import 'package:takween/Features/projects/presentation/views/widgets/project_details_view_body.dart';

class ProjectDetailsView extends StatelessWidget {
  final String projectId;
  final String projectTitle;

  const ProjectDetailsView({
    super.key,
    required this.projectId,
    required this.projectTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 18),
            onPressed: () =>
                context.read<GetProjectDetailsCubit>().refresh(projectId),
          ),
        ],
      ),
      body: ProjectDetailsViewBody(
        projectId: projectId,
        projectTitle: projectTitle,
      ),
    );
  }
}
