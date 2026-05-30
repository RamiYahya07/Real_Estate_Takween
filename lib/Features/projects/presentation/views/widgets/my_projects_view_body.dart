import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:takween/Features/projects/presentation/viewmodels/get_my_projects/get_my_projects_cubit.dart';
import 'package:takween/Features/projects/presentation/viewmodels/get_my_projects/get_my_projects_state.dart';
import 'package:takween/Features/projects/presentation/views/widgets/project_card.dart';
import 'package:takween/core/router/routes.dart';
import 'package:takween/core/theme/colors.dart';

class MyProjectsViewBody extends StatefulWidget {
  const MyProjectsViewBody({super.key});

  @override
  State<MyProjectsViewBody> createState() => _MyProjectsViewBodyState();
}

class _MyProjectsViewBodyState extends State<MyProjectsViewBody> {
  @override
  void initState() {
    super.initState();
    context.read<GetMyProjectsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetMyProjectsCubit, GetMyProjectsState>(
      builder: (context, state) {
        if (state is GetMyProjectsLoadingState ||
            state is GetMyProjectsInitialState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetMyProjectsFailureState) {
          return _ErrorView(
            message: state.message,
            onRetry: () => context.read<GetMyProjectsCubit>().refresh(),
          );
        }

        if (state is GetMyProjectsSuccessState) {
          if (state.projects.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => context.read<GetMyProjectsCubit>().refresh(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: 100.h),
                  Center(
                    child: FaIcon(
                      FontAwesomeIcons.folderOpen,
                      size: 56.sp,
                      color: AppColors.primary.withValues(alpha: 0.4),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Center(
                    child: Text(
                      'No projects yet',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Text(
                        'Projects appear here once a bid is accepted on a land post.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textTertiaryLight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<GetMyProjectsCubit>().refresh(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: state.projects.length,
              itemBuilder: (context, index) {
                final project = state.projects[index];
                return ProjectCard(
                  project: project,
                  onTap: () => context.push(
                    Routes.projectDetails,
                    extra: {
                      'projectId': project.id,
                      'projectTitle': project.title,
                    },
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 40.sp,
              color: AppColors.error,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp),
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
