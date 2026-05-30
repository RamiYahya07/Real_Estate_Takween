import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/posts/data/models/create_post_model.dart';
import 'package:takween/Features/posts/data/repos/land_post_repo.dart';
import 'create_land_post_state.dart';

class CreateLandPostCubit extends Cubit<CreateLandPostState> {
  final LandPostRepo repo;

  CreateLandPostCubit(this.repo)
    : super(CreateLandPostState(model: CreatePostModel()));

  /// =========================
  /// STEP 1-3: update model
  /// =========================

  void updateModel(CreatePostModel model) {
    emit(state.copyWith(model: model));
  }

  /// =========================
  /// CREATE DRAFT
  /// =========================
  Future<void> createDraft() async {
    emit(state.copyWith(status: CreatePostStatus.loading));

    final m = state.model;

    final result = await repo.createDraftLandPost(
      title: m.title!,
      description: m.description!,
      latitude: m.latitude!,
      longitude: m.longitude!,
      city: m.city!,
      neighborhood: m.neighborhood!,
      areaSqm: m.areaSqm!,
      plotWidth: m.plotWidth!,
      plotDepth: m.plotDepth!,
      investmentType: m.investmentType!,
      isSealedAuction: m.isSealedAuction,
      maxAcceptedBids: m.maxAcceptedBids!,
      priceUsd: m.priceUsd!,
      acceptsAdditionalInvestors: m.acceptsAdditionalInvestors,
      desiredBuildingType: m.desiredBuildingType!,
      desiredFloors: m.desiredFloors!,
      specialRequirements: m.specialRequirements!,
      ownershipBasis: m.ownershipBasis!,
      isRepresentative: m.isRepresentative,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CreatePostStatus.failure,
          errorMessage: failure.errMessage,
        ),
      ),
      (post) {
        emit(
          state.copyWith(
            status: CreatePostStatus.draftCreated,
            postId: post.id,
          ),
        );
      },
    );
  }

  /// =========================
  /// UPLOAD DOCUMENTS
  /// =========================
  Future<void> uploadDocs({
    required List<File> files,
    required List<String> types,
  }) async {
    emit(state.copyWith(status: CreatePostStatus.uploadingDocs));

    final result = await repo.uploadLandPostDocuments(
      postId: state.postId!,
      documentFiles: files,
      documentTypes: types,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CreatePostStatus.failure,
          errorMessage: failure.errMessage,
        ),
      ),
      (_) {
        emit(state.copyWith(status: CreatePostStatus.docsUploaded));
      },
    );
  }

  /// =========================
  /// SUBMIT FINAL POST
  /// =========================
  Future<void> submitPost() async {
    emit(state.copyWith(status: CreatePostStatus.submitting));

    final result = await repo.submitDraftLandPost(postId: state.postId!);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CreatePostStatus.failure,
          errorMessage: failure.errMessage,
        ),
      ),
      (_) {
        emit(state.copyWith(status: CreatePostStatus.success));
      },
    );
  }
}
