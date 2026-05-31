import 'package:dartz/dartz.dart';
import 'package:takween/Features/projects/data/models/allocation_result_model.dart';
import 'package:takween/Features/projects/data/models/expense_model.dart';
import 'package:takween/Features/projects/data/models/milestone_model.dart';
import 'package:takween/Features/projects/data/models/project_list_item_model.dart';
import 'package:takween/Features/projects/data/models/project_model.dart';
import 'package:takween/Features/projects/data/models/share_listing_model.dart';
import 'package:takween/Features/projects/data/models/unit_model.dart';
import 'package:takween/Features/payment/data/models/checkout_session.dart';
import 'package:takween/core/errors/failures.dart';

abstract class ProjectRepo {
  Future<Either<Failure, List<ProjectListItemModel>>> getMyProjects();
  Future<Either<Failure, ProjectModel>> getProjectById(String projectId);

  Future<Either<Failure, List<MilestoneModel>>> getMilestones(String projectId);
  Future<Either<Failure, void>> addMilestone({
    required String projectId,
    required String title,
    String? description,
  });
  Future<Either<Failure,void >> updateMilestoneStatus({
    required String projectId,
    required String milestoneId,
    required String status,
  });

  Future<Either<Failure, List<UnitModel>>> getUnits(String projectId);
  Future<Either<Failure, void>> createUnits({
    required String projectId,
    required List<Map<String, dynamic>> units,
  });
  Future<Either<Failure, AllocationResultModel>> allocateUnits(
    String projectId,
  );

  Future<Either<Failure, List<ShareListingModel>>> getShareListings(
    String projectId,
  );
  Future<Either<Failure, void>> createShareListing({
    required String projectId,
    required int shareCount,
    required double pricePerShareUsd,
  });
  Future<Either<Failure, CheckoutSession>> purchaseShareListing({
    required String projectId,
    required String listingId,
  });
  Future<Either<Failure, void>> cancelShareListing({
    required String projectId,
    required String listingId,
  });

  Future<Either<Failure, List<ExpenseModel>>> getExpenses(String projectId);
  Future<Either<Failure, void>> addExpense({
    required String projectId,
    required String category,
    required String description,
    required double amountUsd,
    required DateTime paidAt,
  });
}
