import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:takween/Features/profile/presentation/viewmodels/profile_cubit.dart';
import 'package:takween/Features/profile/presentation/viewmodels/profile_state.dart';
import 'package:takween/Features/profile/presentation/views/widgets/custom_info_tile.dart';
import 'package:takween/core/api/server_strings.dart';
import 'package:takween/core/utils/extensions.dart';

class ProfileViewBody extends StatefulWidget {
  const ProfileViewBody({super.key});

  @override
  State<ProfileViewBody> createState() => _ProfileViewBodyState();
}

class _ProfileViewBodyState extends State<ProfileViewBody> {
  bool isEditing = false;
  File? image;

  final fullNameController = TextEditingController();
  final bioController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();
  final nationalIdController = TextEditingController();

  String? profileImage;

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfile();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    bioController.dispose();
    cityController.dispose();
    phoneController.dispose();
    nationalIdController.dispose();
    super.dispose();
  }

  void fillData(profile) {
    if (profile == null) return;

    fullNameController.text = profile.fullName ?? '';
    bioController.text = profile.bio ?? '';
    cityController.text = profile.city ?? '';
    phoneController.text = profile.phoneNumber ?? '';
    nationalIdController.text = profile.nationalId ?? '';
    profileImage = normalizeImageUrl(profile.avatarUrl) ?? '';
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });
    }
  }

  Widget profileForm(profile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          /// IMAGE
          GestureDetector(
            onTap: isEditing ? pickImage : null,
            child: Stack(
              children: [
                ClipOval(
                  child: image != null
                      ? Image.file(
                          image!,
                          width: 110.w,
                          height: 110.w,
                          fit: BoxFit.cover,
                        )
                      : CachedNetworkImage(
                          imageUrl: profileImage ?? '',
                          width: 110.w,
                          height: 110.w,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) =>
                              const Icon(Icons.person, size: 80),
                        ),
                ),
                if (isEditing)
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(Icons.edit),
                  ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          /// NAME
          Text(
            fullNameController.text,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 20.h),

          /// EDIT BUTTON
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(isEditing ? Icons.check : Icons.edit),
              onPressed: () async {
                final cubit = context.read<ProfileCubit>();

                if (isEditing) {
                  // 1️⃣ Edit profile
                  await cubit.editProfile(
                    fullName: fullNameController.text,
                    bio: bioController.text,
                    city: cityController.text,
                    phoneNumber: phoneController.text,
                    nationalId: nationalIdController.text,
                  );

                  // 2️⃣ Upload image if changed
                  if (image != null) {
                    await cubit.uploadProfileImage(image!);
                  }

                  // 3️⃣ Refresh profile after edit/upload
                  await cubit.getProfile();
                }

                setState(() {
                  isEditing = !isEditing;
                });
              },
            ),
          ),

          SizedBox(height: 10.h),

          /// FORM
          CustomInfoTile(
            label: "Full Name",
            controller: fullNameController,
            isEditing: isEditing,
          ),
          CustomInfoTile(
            label: "Bio",
            controller: bioController,
            isEditing: isEditing,
          ),
          CustomInfoTile(
            label: "City",
            controller: cityController,
            isEditing: isEditing,
          ),
          CustomInfoTile(
            label: "Phone",
            controller: phoneController,
            isEditing: isEditing,
          ),
          CustomInfoTile(
            label: "National ID",
            controller: nationalIdController,
            isEditing: isEditing,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileFailureState ||
                state is ProfileUpdateFailureState ||
                state is UploadImageFailureState) {
              context.showErrorSnackBar('An error occurred');
            }

            if (state is ProfileUpdatedState) {
              context.showSuccessSnackBar('Profile updated');
            }

            if (state is UploadImageSuccessState) {
              context.showSuccessSnackBar('Image uploaded');
            }
          },
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileSuccessState) {
              final profile = state.profile;
              fillData(profile);
              return profileForm(profile);
            }

            if (state is ProfileUpdating || state is UploadImageLoadingState) {
              // Show loading overlay but keep form
              final profile =
                  context.read<ProfileCubit>().state is ProfileSuccessState
                  ? (context.read<ProfileCubit>().state as ProfileSuccessState)
                        .profile
                  : null;

              if (profile != null) fillData(profile);

              return Stack(
                children: [
                  profileForm(profile),
                  const Center(child: CircularProgressIndicator()),
                ],
              );
            }

            return const Center(child: Text("Something went wrong"));
          },
        ),
      ),
    );
  }
}

String? normalizeImageUrl(String? url) {
  if (url == null || url.isEmpty) return null;
  if (url.startsWith('http')) return url;
  return "$kBaseUrlhttp/$url";
}
// add connectivity
//refactor ui
// add noramlizeimageUrl in  