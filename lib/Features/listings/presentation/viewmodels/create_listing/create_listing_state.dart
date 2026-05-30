import 'package:equatable/equatable.dart';

abstract class CreateListingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateListingInitialState extends CreateListingState {}

class CreateListingSubmittingState extends CreateListingState {}

class CreateListingSuccessState extends CreateListingState {
  final String listingId;
  CreateListingSuccessState(this.listingId);

  @override
  List<Object?> get props => [listingId, DateTime.now().microsecondsSinceEpoch];
}

class CreateListingFailureState extends CreateListingState {
  final String message;
  CreateListingFailureState(this.message);

  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}
