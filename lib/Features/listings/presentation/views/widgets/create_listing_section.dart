import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/listings/presentation/viewmodels/create_listing/create_listing_cubit.dart';
import 'package:takween/Features/listings/presentation/viewmodels/create_listing/create_listing_state.dart';
import 'package:takween/Features/listings/presentation/views/widgets/create_listing_bottom_sheet.dart';
import 'package:takween/Features/projects/data/models/project_model.dart';
import 'package:takween/core/data/secure_storage_service.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/constants.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/widgets/custom_button.dart';

class CreateListingSection extends StatefulWidget {
  final ProjectModel project;

  const CreateListingSection({super.key, required this.project});

  @override
  State<CreateListingSection> createState() => _CreateListingSectionState();
}

class _CreateListingSectionState extends State<CreateListingSection> {
  String? _currentUserId;
  Roles _role = Roles.Buyer;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadIdentity();
  }

  Future<void> _loadIdentity() async {
    final storage = sl<SecureStorageService>();
    final id = await storage.getUserId();
    final role = roleFromString(await storage.getRole());
    if (!mounted) return;
    setState(() {
      _currentUserId = id;
      _role = role;
      _loaded = true;
    });
  }

  bool get _isActiveStatus =>
      widget.project.status.toUpperCase() == 'COMPLETED';

  bool get _isProjectLandOwner {
    if (_currentUserId == null || _role != Roles.LandOwner) return false;
    return widget.project.shares.any(
      (s) =>
          s.userId == _currentUserId &&
          s.role.toUpperCase() == 'LANDOWNER',
    );
  }

  bool get _isProjectContractor {
    if (_currentUserId == null || _role != Roles.Contractor) return false;
    return widget.project.shares.any(
      (s) =>
          s.userId == _currentUserId &&
          s.role.toUpperCase() == 'CONTRACTOR',
    );
  }

  void _openSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => BlocProvider(
        create: (_) => sl<CreateListingCubit>(),
        child: BlocConsumer<CreateListingCubit, CreateListingState>(
          listener: (innerCtx, state) {
            if (state is CreateListingSuccessState) {
              Navigator.pop(innerCtx);
              context.showSuccessSnackBar('Listing published');
            }
            if (state is CreateListingFailureState) {
              context.showErrorSnackBar(state.message);
            }
          },
          builder: (innerCtx, state) {
            final submitting = state is CreateListingSubmittingState;
            return CreateListingBottomSheet(
              isSubmitting: submitting,
              onSubmit: ({
                required title,
                description,
                required type,
                required priceUsd,
                areaSqm,
                rooms,
                floor,
              }) async {
                await innerCtx.read<CreateListingCubit>().create(
                      projectId: widget.project.id,
                      title: title,
                      description: description,
                      type: type,
                      priceUsd: priceUsd,
                      areaSqm: areaSqm,
                      rooms: rooms,
                      floor: floor,
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
    if (!_loaded) return const SizedBox.shrink();
    if (!_isActiveStatus) return const SizedBox.shrink();
    if (!_isProjectLandOwner && !_isProjectContractor) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 18.h),
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.house,
              size: 14.sp,
              color: AppColors.primary,
            ),
            SizedBox(width: 8.w),
            Text(
              'Property Listings',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        CustomButton(
          title: 'Publish a Listing',
          icon: Icons.add_home_outlined,
          color: AppColors.primary,
          onTap: _openSheet,
        ),
      ],
    );
  }
}
