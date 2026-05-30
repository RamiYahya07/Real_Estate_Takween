import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/projects/data/models/project_model.dart';
import 'package:takween/Features/projects/presentation/viewmodels/get_project_details/get_project_details_cubit.dart';
import 'package:takween/Features/projects/presentation/viewmodels/pending_payment/pending_payment_cubit.dart';
import 'package:takween/Features/projects/presentation/viewmodels/pending_payment/pending_payment_state.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class PendingPaymentSection extends StatelessWidget {
  final ProjectModel project;

  const PendingPaymentSection({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final pending = project.pendingPayment;
    if (pending == null) return const SizedBox.shrink();

    return BlocProvider(
      create: (_) => sl<PendingPaymentCubit>(),
      child: _PendingPaymentBanner(
        projectId: project.id,
        paymentId: pending.id,
        amount: pending.amountUsd,
        type: pending.type,
      ),
    );
  }
}

class _PendingPaymentBanner extends StatelessWidget {
  final String projectId;
  final String paymentId;
  final double amount;
  final String type;

  const _PendingPaymentBanner({
    required this.projectId,
    required this.paymentId,
    required this.amount,
    required this.type,
  });

  String get _title {
    switch (type.toUpperCase()) {
      case 'BID_PAYMENT':
        return 'Land payment required';
      case 'INVESTOR_DEPOSIT':
        return 'Investment payment required';
      case 'SHARE_PURCHASE':
        return 'Share payment required';
      case 'PROPERTY_PURCHASE':
        return 'Property payment required';
      default:
        return 'Payment required';
    }
  }

  String get _subtitle {
    switch (type.toUpperCase()) {
      case 'BID_PAYMENT':
        return 'Complete payment to finalize the project and receive your shares.';
      case 'INVESTOR_DEPOSIT':
        return 'Your investment was approved. Complete payment to receive your shares.';
      default:
        return 'You have a pending payment for this project.';
    }
  }

  Future<void> _handleCheckout(
    BuildContext context,
    PendingPaymentCheckoutReady state,
  ) async {
    final cubit = context.read<PendingPaymentCubit>();
    final uri = Uri.tryParse(state.checkoutUrl);
    if (uri == null) {
      context.showErrorSnackBar('Invalid checkout link');
      return;
    }
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) {
      if (context.mounted) context.showErrorSnackBar('Could not open checkout');
      return;
    }
    if (!context.mounted) return;
    final paid = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Complete payment'),
        content: const Text(
          'Finish the payment in your browser, then tap "I\'ve paid" to confirm.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text("I've paid"),
          ),
        ],
      ),
    );
    if (paid != true) return;
    await cubit.confirmPayment(state.paymentId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PendingPaymentCubit, PendingPaymentState>(
      listener: (context, state) {
        if (state is PendingPaymentTransientError) {
          context.showErrorSnackBar(state.message);
        }
        if (state is PendingPaymentSuccess) {
          context.showSuccessSnackBar(state.message);
          context.read<GetProjectDetailsCubit>().refresh(projectId);
        }
        if (state is PendingPaymentCheckoutReady) {
          _handleCheckout(context, state);
        }
      },
      builder: (context, state) {
        final isLoading = state is PendingPaymentLoading;
        return Container(
          margin: EdgeInsets.only(bottom: 18.h),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.warning.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.triangleExclamation,
                    size: 16.sp,
                    color: AppColors.warning,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      _title,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                  Text(
                    amount.toCurrency(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                _subtitle,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.primaryMuted,
                ),
              ),
              SizedBox(height: 12.h),
              isLoading
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(6.h),
                        child: const CircularProgressIndicator(),
                      ),
                    )
                  : CustomButton(
                      title: 'Pay Now',
                      icon: Icons.payment_rounded,
                      color: AppColors.primary,
                      onTap: () =>
                          context.read<PendingPaymentCubit>().pay(paymentId),
                    ),
            ],
          ),
        );
      },
    );
  }
}
