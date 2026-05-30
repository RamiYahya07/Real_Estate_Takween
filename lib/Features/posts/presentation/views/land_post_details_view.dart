import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:takween/Features/posts/presentation/views/widgets/land_post_details_view_body.dart';
import 'package:takween/core/utils/app_strings.dart';
import 'package:takween/core/utils/extensions.dart';

class LandPostDetailsView extends StatelessWidget {
  final String postId;
  final bool canEdit;
  final bool canDelete;
  final bool canViewBids;
  const LandPostDetailsView({
    super.key,
    required this.postId,
    this.canEdit = false,
    this.canDelete = false,
    this.canViewBids = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: FaIcon(FontAwesomeIcons.xmark),
        ),
        title: Text(AppStrings.postDetails.tr().capitalizeWords()),
        centerTitle: true,
      ),
      body: LandPostDetailsViewBody(
        postId: postId,
        canEdit: canEdit,
        canDelete: canDelete,
        canViewBids: canViewBids,
      ),
    );
  }
}
