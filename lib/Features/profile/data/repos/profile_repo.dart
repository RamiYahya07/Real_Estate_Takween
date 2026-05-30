import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:takween/Features/profile/data/models/profile_model.dart';
import 'package:takween/core/errors/failures.dart';

abstract class ProfileRepo {
  Future<Either<Failure, ProfileModel>> getProfile();
  Future<Either<Failure, void>> editProfile({
   required String fullName,
   required String bio,
   required String city,
 required   String phoneNumber,
  required  String nationalId,
  });

  Future<Either<Failure, void>> uploadProfilePicture({
    required File imageFile
  });
}
