
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:takween/Features/posts/presentation/viewmodels/create_land_post/create_land_post_cubit.dart';
import 'package:takween/Features/posts/presentation/views/post_details_step_view.dart';
import 'package:takween/Features/posts/presentation/views/post_investement_step_veiw.dart';
import 'package:takween/Features/posts/presentation/views/post_propertyspecs_step_view.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/utils/app_strings.dart';

class PostViewBody extends StatefulWidget {
  const PostViewBody({super.key});

  @override
  State<PostViewBody> createState() => _PostViewBodyState();
}

class _PostViewBodyState extends State<PostViewBody> {
  final PageController _controller = PageController();

  void nextPage() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CreateLandPostCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.postTitleScreen.tr()),
          leading: IconButton(
            icon: FaIcon(FontAwesomeIcons.xmark),
            onPressed: context.pop,
          ),
        ),
        body: PageView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            PostDetailsStepView(onNext: nextPage),

            PostPropertySpecsStepView(onNext: nextPage, onBack: previousPage),

            PostInvestmentStepView(onNext: nextPage, onBack: previousPage),

            PostUploadDocsStepView(),
          ],
        ),
      ),
    );
  }
}

class PostUploadDocsStepView extends StatelessWidget {
  const PostUploadDocsStepView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
