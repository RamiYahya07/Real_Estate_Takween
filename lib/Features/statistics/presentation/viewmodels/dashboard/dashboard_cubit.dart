import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/statistics/data/models/buyer_stats_model.dart';
import 'package:takween/Features/statistics/data/models/contractor_dashboard_model.dart';
import 'package:takween/Features/statistics/data/models/landOwner_dashboard_model.dart';
import 'package:takween/Features/statistics/data/models/listing_statistics_model.dart';
import 'package:takween/Features/statistics/data/models/project_statistics_model.dart';
import 'package:takween/Features/statistics/data/models/shares_statistics_model.dart';
import 'package:takween/Features/statistics/data/repos/statistics_repo.dart';
import 'package:takween/Features/statistics/presentation/viewmodels/dashboard/dashboard_state.dart';
import 'package:takween/core/data/secure_storage_service.dart';
import 'package:takween/core/utils/constants.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final StatisticsRepo repo;
  final SecureStorageService storage;

  DashboardCubit(this.repo, this.storage) : super(DashboardInitialState());

  Future<void> load() async {
    emit(DashboardLoadingState());

    final roleString = await storage.getRole();
    final role = roleFromString(roleString);

    if (role == Roles.Buyer || role == Roles.Investor) {
      await _loadBuyer(role);
      return;
    }

    LandownerDashboardModel? landowner;
    ContractorDashboardModel? contractor;
    ProjectStatisticsModel? projects;
    SharesStatisticsModel? shares;
    ListingStatisticsModel? listings;
    final partialErrors = <String>[];

    if (role == Roles.LandOwner) {
      final r = await repo.getLandOwnerDashboardData();
      r.fold(
        (f) => partialErrors.add('Owner stats: ${f.errMessage}'),
        (d) => landowner = d,
      );
    } else if (role == Roles.Contractor) {
      final r = await repo.getContractorDashboardData();
      r.fold(
        (f) => partialErrors.add('Contractor stats: ${f.errMessage}'),
        (d) => contractor = d,
      );
    }

    final projectsRes = await repo.getProjectStatisticsData();
    projectsRes.fold(
      (f) => partialErrors.add('Projects: ${f.errMessage}'),
      (d) => projects = d,
    );

    final sharesRes = await repo.getSharesStatisticsData();
    sharesRes.fold(
      (f) => partialErrors.add('Shares: ${f.errMessage}'),
      (d) => shares = d,
    );

    final listingsRes = await repo.getListingStatisticsData();
    listingsRes.fold(
      (f) => partialErrors.add('Listings: ${f.errMessage}'),
      (d) => listings = d,
    );

    final allFailed = landowner == null &&
        contractor == null &&
        projects == null &&
        shares == null &&
        listings == null;
    if (allFailed) {
      emit(
        DashboardFailureState(
          partialErrors.isEmpty
              ? 'Failed to load dashboard'
              : partialErrors.join('\n'),
        ),
      );
      return;
    }

    emit(
      DashboardLoadedState(
        role: role.name,
        landowner: landowner,
        contractor: contractor,
        projects: projects,
        shares: shares,
        listings: listings,
        partialErrorMessage:
            partialErrors.isEmpty ? null : partialErrors.join('\n'),
      ),
    );
  }

  Future<void> _loadBuyer(Roles role) async {
    final res = await repo.getBuyerStatsData();
    res.fold(
      (f) => emit(DashboardFailureState(f.errMessage)),
      (BuyerStatsModel d) => emit(
        DashboardLoadedState(role: role.name, buyer: d),
      ),
    );
  }

  Future<void> refresh() => load();
}
