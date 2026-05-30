import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/contract/presentation/viewmodels/contract/contract_cubit.dart';
import 'package:takween/Features/contract/presentation/viewmodels/contract/contract_state.dart';
import 'package:takween/Features/contract/presentation/views/widgets/contract_participant_tile.dart';
import 'package:takween/Features/contract/presentation/views/widgets/contract_status_card.dart';
import 'package:takween/Features/contract/presentation/views/widgets/generate_contract_card.dart';
import 'package:takween/Features/contract/presentation/views/widgets/sign_contract_bottom_sheet.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ContractViewBody extends StatelessWidget {
  final String projectId;

  const ContractViewBody({super.key, required this.projectId});

  bool _canSign(ContractLoadedState state) {
    if ((state.contract.status ?? '').toUpperCase() == 'FULLY_SIGNED')
      return false;
    final me = state.currentUserId;
    if (me == null) return false;
    final mine = state.contract.participants
        .where((p) => p.userId == me)
        .toList();
    if (mine.isEmpty) return false;
    return !mine.first.hasSigned;
  }

  Future<void> _openPdf(BuildContext context, String url) async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) {
      context.showErrorSnackBar('Invalid PDF URL');
      return;
    }
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      context.showErrorSnackBar('Could not open PDF');
    }
  }

  void _openSignSheet(BuildContext context, ContractLoadedState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => BlocProvider.value(
        value: context.read<ContractCubit>(),
        child: BlocBuilder<ContractCubit, ContractState>(
          builder: (innerCtx, s) {
            final isSigning = s is ContractLoadedState && s.isSigning;
            return SignContractBottomSheet(
              isSigning: isSigning,
              onSign: (passphrase) async {
                await innerCtx.read<ContractCubit>().sign(
                  projectId: projectId,
                  passphrase: passphrase,
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContractCubit, ContractState>(
      listener: (context, state) {
        if (state is ContractTransientError) {
          context.showErrorSnackBar(state.message);
        }
        // if (state is ContractSignSuccessState) {
        //   context.showSuccessSnackBar(
        //     (state.contract.status??'').toUpperCase() == 'FULLY_SIGNED'
        //         ? 'Contract fully signed'
        //         : 'You have signed the contract',
        //   );
        // }
        if (state is ContractSignSuccessState) {
          context.showSuccessSnackBar('Contract signed successfully');
          //  refresh UI after signing
          context.read<ContractCubit>().load(projectId);
        }
        ;
      },
      buildWhen: (previous, current) =>
          current is! ContractTransientError &&
          current is! ContractSignSuccessState,
      builder: (context, state) {
        if (state is ContractInitialState || state is ContractLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ContractFailureState) {
          return _ErrorView(
            message: state.message,
            onRetry: () => context.read<ContractCubit>().load(projectId),
          );
        }

        if (state is ContractNotGeneratedState) {
          return RefreshIndicator(
            onRefresh: () => context.read<ContractCubit>().load(projectId),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 40.h),
                GenerateContractCard(
                  isLandOwner: state.isLandOwner,
                  isGenerating: state.isGenerating,
                  onGenerate: () =>
                      context.read<ContractCubit>().generate(projectId),
                ),
              ],
            ),
          );
        }

        if (state is ContractLoadedState) {
          final contract = state.contract;
          final canSign = _canSign(state);

          return RefreshIndicator(
            onRefresh: () => context.read<ContractCubit>().refresh(projectId),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              children: [
                ContractStatusCard(
                  contract: contract,
                  onOpenPdf: () => _openPdf(context, contract.pdfUrl ?? ''),
                ),
                SizedBox(height: 16.h),
                _SectionHeader(
                  icon: FontAwesomeIcons.userGroup,
                  title: 'Participants (${contract.participants.length})',
                ),
                SizedBox(height: 8.h),
                ...contract.participants.map(
                  (p) => ContractParticipantTile(
                    participant: p,
                    isCurrentUser: p.userId == state.currentUserId,
                  ),
                ),
                if (canSign) ...[
                  SizedBox(height: 16.h),
                  CustomButton(
                    title: 'Sign Contract',
                    icon: Icons.draw_outlined,
                    color: AppColors.accent,
                    onTap: () => _openSignSheet(context, state),
                  ),
                ],
                if (contract.fullySignedAt != null) ...[
                  SizedBox(height: 16.h),
                  _FullySignedBanner(signedAt: contract.fullySignedAt!),
                ],
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final FaIconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(icon, size: 14.sp, color: AppColors.primary),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _FullySignedBanner extends StatelessWidget {
  final DateTime signedAt;

  const _FullySignedBanner({required this.signedAt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.shieldHalved,
            color: AppColors.success,
            size: 18.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contract fully signed',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Completed on ${signedAt.toLocal().formattedDateTime}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textTertiaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
