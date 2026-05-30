import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/projects/presentation/viewmodels/get_my_projects/get_my_projects_cubit.dart';
import 'package:takween/Features/projects/presentation/views/widgets/my_projects_view_body.dart';
import 'package:takween/core/di/injection.dart';

class MyProjectsView extends StatelessWidget {
  const MyProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GetMyProjectsCubit>(),
      child: const MyProjectsViewBody(),
    );
  }
}
