import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/listings/data/repos/listing_repo.dart';
import 'package:takween/Features/listings/presentation/viewmodels/create_listing/create_listing_state.dart';

class CreateListingCubit extends Cubit<CreateListingState> {
  final ListingRepo repo;

  CreateListingCubit(this.repo) : super(CreateListingInitialState());

  Future<void> create({
    required String projectId,
    required String title,
    String? description,
    required String type,
    required double priceUsd,
    double? areaSqm,
    int? rooms,
    int? floor,
    List<String>? photoUrls,
  }) async {
    if (title.trim().isEmpty) {
      emit(CreateListingFailureState('Title is required'));
      return;
    }
    if (priceUsd <= 0) {
      emit(CreateListingFailureState('Price must be greater than 0'));
      return;
    }

    emit(CreateListingSubmittingState());

    final result = await repo.create(
      projectId: projectId,
      title: title.trim(),
      description: description?.trim(),
      type: type,
      priceUsd: priceUsd,
      areaSqm: areaSqm,
      rooms: rooms,
      floor: floor,
      photoUrls: photoUrls,
    );

    result.fold(
      (failure) => emit(CreateListingFailureState(failure.errMessage)),
      (id) => emit(CreateListingSuccessState(id)),
    );
  }

  void reset() => emit(CreateListingInitialState());
}
