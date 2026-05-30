

import 'package:takween/Features/posts/data/models/land_post_item_details_model.dart';

abstract class GetLandPostDetailsState {}

class GetLandPostDetailsInitialState extends GetLandPostDetailsState {}

class GetLandPostDetailsLoadingState extends GetLandPostDetailsState {}

class GetLandPostDetailsSuccessState extends GetLandPostDetailsState {
  final LandPostItemDetailsModel data;

  GetLandPostDetailsSuccessState(this.data);
}

class GetLandPostDetailsFailureState extends GetLandPostDetailsState {
  final String message;

  GetLandPostDetailsFailureState(this.message);
}