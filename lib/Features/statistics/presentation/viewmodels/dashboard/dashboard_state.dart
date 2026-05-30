import 'package:equatable/equatable.dart';
import 'package:takween/Features/statistics/data/models/buyer_stats_model.dart';
import 'package:takween/Features/statistics/data/models/contractor_dashboard_model.dart';
import 'package:takween/Features/statistics/data/models/landOwner_dashboard_model.dart';
import 'package:takween/Features/statistics/data/models/listing_statistics_model.dart';
import 'package:takween/Features/statistics/data/models/project_statistics_model.dart';
import 'package:takween/Features/statistics/data/models/shares_statistics_model.dart';

abstract class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DashboardInitialState extends DashboardState {}

class DashboardLoadingState extends DashboardState {}

class DashboardLoadedState extends DashboardState {
  final String role;
  final LandownerDashboardModel? landowner;
  final ContractorDashboardModel? contractor;
  final ProjectStatisticsModel? projects;
  final SharesStatisticsModel? shares;
  final ListingStatisticsModel? listings;
  final BuyerStatsModel? buyer;
  final String? partialErrorMessage;

  DashboardLoadedState({
    required this.role,
    this.landowner,
    this.contractor,
    this.projects,
    this.shares,
    this.listings,
    this.buyer,
    this.partialErrorMessage,
  });

  @override
  List<Object?> get props => [
        role,
        landowner,
        contractor,
        projects,
        shares,
        listings,
        buyer,
        partialErrorMessage,
      ];
}

class DashboardFailureState extends DashboardState {
  final String message;
  DashboardFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
