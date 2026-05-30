import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:takween/Features/posts/data/repos/land_post_repo.dart';

part 'edit_land_post_state.dart';

class EditLandPostCubit extends Cubit<EditLandPostState> {
  final LandPostRepo repo;
  EditLandPostCubit(this.repo) : super(EditLandPostInitialState());

  Future<void> editLandPost({
    required String postId,
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required String city,
    required String neighborhood,
    required double areaSqm,
    required double plotWidth,
    required double plotDepth,
    required String investmentType,
    required bool isSealedAuction,
    required int maxAcceptedBids,
    required double priceUsd,
    required double pricePerShareUsd,
    required bool acceptsAdditionalInvestors,
    required String desiredBuildingType,
    required int desiredFloors,
    required String specialRequirements,
    required String ownershipBasis,
    required bool isRepresentative,
  }) async {
    emit(EditLandPostLoadingState());

    final result = await repo.editLandPost(
      postId: postId,
      title: title,
      description: description,
      latitude: latitude,
      longitude: longitude,
      city: city,
      neighborhood: neighborhood,
      areaSqm: areaSqm,
      plotWidth: plotWidth,
      plotDepth: plotDepth,
      investmentType: investmentType,
      isSealedAuction: isSealedAuction,
      maxAcceptedBids: maxAcceptedBids,
      priceUsd: priceUsd,
      pricePerShareUsd: pricePerShareUsd,
      acceptsAdditionalInvestors: acceptsAdditionalInvestors,
      desiredBuildingType: desiredBuildingType,
      desiredFloors: desiredFloors,
      specialRequirements: specialRequirements,
      ownershipBasis: ownershipBasis,
      isRepresentative: isRepresentative,
    );

    result.fold(
      (failure) => emit(EditLandPostFailure(failure.errMessage)),
      (_) => emit(EditLandPostSuccessState()),
    );
  }
}
