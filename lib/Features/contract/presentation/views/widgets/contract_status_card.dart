import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/contract/data/models/contract_model.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';

class ContractStatusCard extends StatelessWidget {
  final ContractModel contract;
  final VoidCallback onOpenPdf;

  const ContractStatusCard({
    super.key,
    required this.contract,
    required this.onOpenPdf,
  });

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'FULLY_SIGNED':
        return AppColors.success;
      case 'PENDING_SIGNATURE':
      case 'PARTIALLY_SIGNED':
        return AppColors.warning;
      case 'EXPIRED':
      case 'CANCELLED':
        return AppColors.error;
      default:
        return AppColors.primaryMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = contract.status ?? '';
    final summary = contract.summary ?? '';
    final pdfUrl = contract.pdfUrl ?? '';
    final investmentType = contract.investmentType ?? '';
    final hash = contract.documentHash ?? '';

    final statusColor = _statusColor(contract.status ?? '');
    final progress = contract.requiredSignatures == 0
        ? 0.0
        : (contract.signedCount / contract.requiredSignatures).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
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
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.fileContract,
                color: AppColors.primary,
                size: 18.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Contract',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  status.replaceAll('_', ' '),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (summary.isNotEmpty)
            Text(
              contract.summary ?? '',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textTertiaryLight,
                height: 1.4,
              ),
            ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Signatures',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textTertiaryLight,
                ),
              ),
              Text(
                '${contract.signedCount} / ${contract.requiredSignatures}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: AppColors.primaryContainerLight,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _MetaTile(
                  icon: FontAwesomeIcons.layerGroup,
                  label: 'Total Shares',
                  value: contract.totalShares.toString(),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _MetaTile(
                  icon: FontAwesomeIcons.dollarSign,
                  label: 'Value',
                  value: contract.totalValueUsd != null
                      ? contract.totalValueUsd!.toCurrency()
                      : '--',
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          _MetaTile(
            icon: FontAwesomeIcons.handshake,
            label: 'Investment',
            value: investmentType.replaceAll('_', ' '),
          ),
          SizedBox(height: 14.h),
          if (pdfUrl.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onOpenPdf,
                icon: const FaIcon(FontAwesomeIcons.filePdf, size: 16),
                label: const Text('Open Contract PDF'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                ),
                ),
              ),
            ),
          if (hash.isNotEmpty) ...[
            SizedBox(height: 10.h),
            _DocumentHashRow(hash: hash),
          ],
        ],
      ),
    );
  }
}

class _MetaTile extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final String value;

  const _MetaTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.primaryContainerLight.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          FaIcon(icon, size: 14.sp, color: AppColors.primary),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textTertiaryLight,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentHashRow extends StatelessWidget {
  final String hash;

  const _DocumentHashRow({required this.hash});

  String _short(String s) => s.length <= 16
      ? s
      : '${s.substring(0, 8)}...${s.substring(s.length - 6)}';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(
          FontAwesomeIcons.fingerprint,
          size: 12.sp,
          color: AppColors.textTertiaryLight,
        ),
        SizedBox(width: 6.w),
        Text(
          'Hash:',
          style: TextStyle(fontSize: 10.sp, color: AppColors.textTertiaryLight),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            _short(hash),
            style: TextStyle(
              fontSize: 10.sp,
              fontFamily: 'monospace',
              color: AppColors.primaryMuted,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
