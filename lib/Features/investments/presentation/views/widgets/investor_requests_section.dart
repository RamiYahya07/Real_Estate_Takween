import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/investments/data/models/investor_request_model.dart';
import 'package:takween/Features/investments/presentation/viewmodels/investor_review/investor_review_cubit.dart';
import 'package:takween/Features/investments/presentation/viewmodels/investor_review/investor_review_state.dart';
import 'package:takween/Features/projects/data/models/project_model.dart';
import 'package:takween/core/data/secure_storage_service.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';

class InvestorRequestsSection extends StatefulWidget {
  final ProjectModel project;

  const InvestorRequestsSection({super.key, required this.project});

  @override
  State<InvestorRequestsSection> createState() =>
      _InvestorRequestsSectionState();
}

class _InvestorRequestsSectionState extends State<InvestorRequestsSection> {
  String? _currentUserId;
  bool _resolved = false;

  @override
  void initState() {
    super.initState();
    _resolveIdentity();
  }

  Future<void> _resolveIdentity() async {
    final id = await sl<SecureStorageService>().getUserId();
    if (!mounted) return;
    setState(() {
      _currentUserId = id;
      _resolved = true;
    });
  }

  bool get _isJointInvestment =>
      widget.project.investmentType.toUpperCase() == 'JOINT_INVESTMENT';

  bool get _isReviewer {
    final me = _currentUserId;
    if (me == null) return false;
    return widget.project.shares.any(
      (s) =>
          s.userId == me &&
          (s.role.toUpperCase() == 'LANDOWNER' ||
              s.role.toUpperCase() == 'CONTRACTOR'),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_resolved) return const SizedBox.shrink();
    if (!_isJointInvestment) return const SizedBox.shrink();
    if (!_isReviewer) return const SizedBox.shrink();

    return BlocProvider(
      create: (_) => sl<InvestorReviewCubit>()..load(widget.project.id),
      child: _SectionBody(projectId: widget.project.id),
    );
  }
}

class _SectionBody extends StatelessWidget {
  final String projectId;
  const _SectionBody({required this.projectId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvestorReviewCubit, InvestorReviewState>(
      listener: (context, state) {
        if (state is InvestorReviewTransientError) {
          context.showErrorSnackBar(state.message);
        }
        if (state is InvestorReviewActionSuccess) {
          context.showSuccessSnackBar(state.message);
        }
      },
      buildWhen: (prev, curr) =>
          curr is! InvestorReviewTransientError &&
          curr is! InvestorReviewActionSuccess,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(top: 18.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.handHoldingDollar,
                    size: 14.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Investor Requests',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              _content(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _content(BuildContext context, InvestorReviewState state) {
    if (state is InvestorReviewInitial || state is InvestorReviewLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (state is InvestorReviewFailure) {
      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 14.sp,
              color: AppColors.error,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                state.message,
                style: TextStyle(fontSize: 11.sp, color: AppColors.error),
              ),
            ),
            TextButton(
              onPressed: () =>
                  context.read<InvestorReviewCubit>().load(projectId),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (state is InvestorReviewLoaded) {
      if (state.requests.isEmpty) {
        return Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.primaryContainerLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.circleInfo,
                size: 14.sp,
                color: AppColors.primaryMuted,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'No investor requests yet.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primaryMuted,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return Column(
        children: state.requests
            .map(
              (r) => _RequestTile(
                request: r,
                isProcessing: state.processingRequestId == r.id,
                onApprove: () => context.read<InvestorReviewCubit>().review(
                      projectId: projectId,
                      requestId: r.id,
                      approve: true,
                    ),
                onReject: () => context.read<InvestorReviewCubit>().review(
                      projectId: projectId,
                      requestId: r.id,
                      approve: false,
                    ),
              ),
            )
            .toList(),
      );
    }
    return const SizedBox.shrink();
  }
}

class _RequestTile extends StatelessWidget {
  final InvestorRequestModel request;
  final bool isProcessing;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _RequestTile({
    required this.request,
    required this.isProcessing,
    required this.onApprove,
    required this.onReject,
  });

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'APPROVED':
        return AppColors.success;
      case 'REJECTED':
        return AppColors.error;
      case 'PAID':
        return AppColors.info;
      case 'PENDING':
        return AppColors.warning;
      default:
        return AppColors.primaryMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPending = request.status.toUpperCase() == 'PENDING';
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.borderLight.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  request.investorName.isEmpty
                      ? 'Investor'
                      : request.investorName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: _statusColor(request.status).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  request.status,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: _statusColor(request.status),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: _Meta(
                  label: 'Amount',
                  value: request.investmentAmountUsd.toCurrency(),
                ),
              ),
              Expanded(
                child: _Meta(
                  label: 'Shares',
                  value: '${request.requestedShares} / 2400',
                ),
              ),
            ],
          ),
          if (request.notes != null && request.notes!.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              request.notes!,
              style: TextStyle(fontSize: 11.sp, color: AppColors.primaryMuted),
            ),
          ],
          if (isPending) ...[
            SizedBox(height: 10.h),
            isProcessing
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(6.h),
                      child: const CircularProgressIndicator(),
                    ),
                  )
                : Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onReject,
                          icon: FaIcon(
                            FontAwesomeIcons.xmark,
                            size: 12.sp,
                            color: AppColors.error,
                          ),
                          label: Text(
                            'Reject',
                            style: TextStyle(color: AppColors.error),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.error),
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onApprove,
                          icon: FaIcon(
                            FontAwesomeIcons.check,
                            size: 12.sp,
                            color: Colors.white,
                          ),
                          label: const Text('Approve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final String label;
  final String value;
  const _Meta({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: AppColors.primaryMuted),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
