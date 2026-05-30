import 'package:dartz/dartz.dart';
import 'package:takween/Features/statistics/data/models/buyer_stats_model.dart';
import 'package:takween/Features/statistics/data/models/contractor_dashboard_model.dart';
import 'package:takween/Features/statistics/data/models/landOwner_dashboard_model.dart';
import 'package:takween/Features/statistics/data/models/listing_statistics_model.dart';
import 'package:takween/Features/statistics/data/models/project_statistics_model.dart';
import 'package:takween/Features/statistics/data/models/shares_statistics_model.dart';
import 'package:takween/core/errors/failures.dart';

abstract class StatisticsRepo{
Future<Either<Failure, ContractorDashboardModel>> getContractorDashboardData();

Future<Either<Failure, LandownerDashboardModel>> getLandOwnerDashboardData();

Future<Either<Failure, ProjectStatisticsModel>> getProjectStatisticsData();

Future<Either<Failure, SharesStatisticsModel>> getSharesStatisticsData();

Future<Either<Failure,ListingStatisticsModel>> getListingStatisticsData();

Future<Either<Failure, BuyerStatsModel>> getBuyerStatsData();
}