import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:takween/Features/feasibility/presentation/views/widgets/preliminary_feasibility_section.dart';
import 'package:takween/Features/posts/presentation/viewmodels/delete_land_post/delete_land_post_cubit.dart';
import 'package:takween/Features/posts/presentation/viewmodels/edit_land_post/edit_land_post_cubit.dart';
import 'package:takween/Features/posts/presentation/viewmodels/get_land_post_item_details/get_land_post_details_cubit.dart';
import 'package:takween/Features/posts/presentation/viewmodels/get_land_post_item_details/get_land_post_details_state.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/router/routes.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';

class LandPostDetailsViewBody extends StatelessWidget {
  final String postId;
  final bool canEdit;
  final bool canDelete;
  final bool canViewBids;
  const LandPostDetailsViewBody({
    super.key,
    required this.postId,
    this.canEdit = false,
    this.canDelete = false,
    this.canViewBids = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetLandPostDetailsCubit(sl())..getDetails(postId),
        ),
        BlocProvider(create: (_) => DeleteLandPostCubit(sl())),
        BlocProvider(create: (_) => EditLandPostCubit(sl())),
      ],
      child: MultiBlocListener(
        listeners: [
          /// 🔴 DELETE
          BlocListener<DeleteLandPostCubit, DeleteLandPostState>(
            listener: (context, state) {
              if (state is DeleteLandPostLoadingState) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );
              } else if (state is DeleteLandPostSuccessState) {
                context.pop();
                context.pop(true);
                context.showSuccessSnackBar("Post deleted");
              } else if (state is DeleteLandPostFailure) {
                context.pop();
                context.showErrorSnackBar(state.errMessage);
              }
            },
          ),

          /// ✏️ EDIT
          BlocListener<EditLandPostCubit, EditLandPostState>(
            listener: (context, state) {
              if (state is EditLandPostLoadingState) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );
              } else if (state is EditLandPostSuccessState) {
                Navigator.pop(context);
                context.showSuccessSnackBar("Post updated");
              } else if (state is EditLandPostFailure) {
                Navigator.pop(context);
                context.showErrorSnackBar(state.errMessage);
              }
            },
          ),
        ],

        child: BlocBuilder<GetLandPostDetailsCubit, GetLandPostDetailsState>(
          builder: (context, state) {
            /// 🔹 Loading
            if (state is GetLandPostDetailsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            /// 🔹 Failure
            if (state is GetLandPostDetailsFailureState) {
              return Center(child: Text(state.message));
            }

            /// 🔹 Success
            if (state is GetLandPostDetailsSuccessState) {
              final post = state.data;

              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔥 HEADER
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Title + Actions
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  post.title,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: context.colorScheme.onSurface,
                                  ),
                                ),
                              ),

                              /// ✏️ EDIT
                              if (canEdit)
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: AppColors.primary,
                                  ),
                                  onPressed: () {
                                    context.push(
                                      Routes.editLandPostDetails,
                                      extra: post,
                                    );
                                  },
                                ),

                              /// 🗑 DELETE
                              if (canDelete)
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () =>
                                      _showDeleteDialog(context, post.id),
                                ),

                              /// STATUS
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: post.status.statusColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  post.status,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: post.status.statusColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10.h),

                          /// Price
                          Text(
                            post.priceUsd != null
                                ? '\$${post.priceUsd!.toStringAsFixed(0)}'
                                : 'N/A',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),

                          SizedBox(height: 8.h),

                          /// Location
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16.sp),
                              SizedBox(width: 6.w),
                              Text(
                                '${post.city}, ${post.neighborhood}',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    /// 🔹 OVERVIEW
                    _sectionCard(
                      context,
                      title: "Overview",
                      children: [
                        _infoRow("Area", "${post.areaSqm} m²"),
                        _infoRow("Investment", post.investmentType),
                        _infoRow("Building Type", post.desiredBuildingType),
                        _infoRow("Bids", "${post.bidCount}"),
                        _infoRow("Accepted", "${post.acceptedBidCount}"),
                        _infoRow("Bids", "${post.bidCount}"),

                        SizedBox(height: 10.h),

                        if (canViewBids)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.gavel),
                              label: Text("View Bids"),
                              onPressed: () {
                                context.push(Routes.postBids, extra: post.id);
                              },
                            ),
                          ),
                      ],
                    ),

                    /// 🔹 DESCRIPTION
                    if (post.description != null &&
                        post.description!.isNotEmpty) ...[
                      SizedBox(height: 16.h),
                      _sectionCard(
                        context,
                        title: "Description",
                        children: [
                          Text(
                            post.description!,
                            style: TextStyle(fontSize: 13.sp),
                          ),
                        ],
                      ),
                    ],

                    /// 🔹 BUILDABLE AREA
                    if (post.buildableArea != null) ...[
                      SizedBox(height: 16.h),
                      _sectionCard(
                        context,
                        title: "Buildable Area",
                        children: [
                          _infoRow(
                            "Total Area",
                            "${post.buildableArea!.totalBuildableAreaSqm} m²",
                          ),
                          _infoRow(
                            "Floors",
                            "${post.buildableArea!.maxAllowedFloors}",
                          ),
                          _infoRow(
                            "Height",
                            "${post.buildableArea!.estimatedBuildingHeightM} m",
                          ),
                          _infoRow(
                            "Basement",
                            post.buildableArea!.basementAllowed
                                ? "Allowed"
                                : "Not Allowed",
                          ),
                        ],
                      ),
                    ],

                    /// 🔹 ZONE INFO
                    if (post.zoneInfo != null) ...[
                      SizedBox(height: 16.h),
                      _sectionCard(
                        context,
                        title: "Zone Info",
                        children: [
                          _infoRow("Zone", post.zoneInfo!.zoneNameEn),
                          _infoRow("Type", post.zoneInfo!.zoneType),
                          _infoRow("Max Floors", "${post.zoneInfo!.maxFloors}"),
                          _infoRow(
                            "Max Height",
                            "${post.zoneInfo!.maxHeightM} m",
                          ),
                          _infoRow(
                            "Coverage",
                            "${post.zoneInfo!.maxCoveragePct}%",
                          ),
                        ],
                      ),
                    ],

                    PreliminaryFeasibilitySection(landPostId: post.id),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  /// 🔴 DELETE DIALOG
  void _showDeleteDialog(BuildContext context, String postId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text("Are you sure you want to delete this post?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<DeleteLandPostCubit>().deleteLandPost(postId);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// 🔹 SECTION CARD
  Widget _sectionCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10.h),
          ...children,
        ],
      ),
    );
  }

  /// 🔹 INFO ROW
  Widget _infoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textTertiaryLight,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
