import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:takween/Features/projects/data/models/allocation_result_model.dart';
import 'package:takween/Features/projects/data/models/expense_model.dart';
import 'package:takween/Features/projects/data/models/milestone_model.dart';
import 'package:takween/Features/projects/data/models/project_list_item_model.dart';
import 'package:takween/Features/projects/data/models/project_model.dart';
import 'package:takween/Features/projects/data/models/share_listing_model.dart';
import 'package:takween/Features/projects/data/models/unit_model.dart';
import 'package:takween/Features/payment/data/models/checkout_session.dart';
import 'package:takween/Features/projects/data/repos/project_repo.dart';
import 'package:takween/core/api/api_consumer.dart';
import 'package:takween/core/api/api_response.dart';
import 'package:takween/core/api/server_strings.dart';
import 'package:takween/core/errors/failures.dart';

class ProjectRepoImpl implements ProjectRepo {
  final ApiConsumer api;

  ProjectRepoImpl(this.api);

  @override
  Future<Either<Failure, List<ProjectListItemModel>>> getMyProjects() async {
    try {
      final response = await api.get(EndPoints.kMyProjects);
      final apiResponse = ApiResponse.fromJson(response, (data) => data);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to load projects'),
        );
      }
      final raw = apiResponse.data;
      final List items = raw is List ? raw : (raw?['items'] as List? ?? []);
      final projects = items
          .map((e) => ProjectListItemModel.fromJson(e))
          .toList();
      return right(projects);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, ProjectModel>> getProjectById(String projectId) async {
    try {
      final response = await api.get(EndPoints.kProjectById(projectId));
      final apiResponse = ApiResponse<ProjectModel>.fromJson(
        response,
        (data) => ProjectModel.fromJson(data as Map<String, dynamic>),
      );
      if (!apiResponse.success || apiResponse.data == null) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to load project'),
        );
      }
      return right(apiResponse.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<MilestoneModel>>> getMilestones(
    String projectId,
  ) async {
    try {
      final response = await api.get(EndPoints.kProjectMilestones(projectId));
      final apiResponse = ApiResponse.fromJson(response, (data) => data);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to load milestones'),
        );
      }
      final raw = apiResponse.data;
      final List items = raw is List ? raw : (raw?['items'] as List? ?? []);
      final milestones = items.map((e) => MilestoneModel.fromJson(e)).toList();
      return right(milestones);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> addMilestone({
    required String projectId,
    required String title,
    String? description,
  }) async {
    try {
      final body = <String, dynamic>{'title': title};
      if (description != null && description.isNotEmpty) {
        body['description'] = description;
      }
      final response = await api.post(
        EndPoints.kProjectMilestones(projectId),
        body: body,
      );
      final apiResponse = ApiResponse<dynamic>.fromJson(
        response,
        (data) => data,
      );

      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to add milestone'),
        );
      }
      return right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, MilestoneModel>> updateMilestoneStatus({
    required String projectId,
    required String milestoneId,
    required String status,
  }) async {
    try {
      final response = await api.put(
        EndPoints.kProjectMilestoneStatus(projectId, milestoneId),
        body: {'status': status},
      );
      final apiResponse = ApiResponse<MilestoneModel>.fromJson(
        response,
        (data) => MilestoneModel.fromJson(data as Map<String, dynamic>),
      );
      if (!apiResponse.success || apiResponse.data == null) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to update status'),
        );
      }
      return right(apiResponse.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<UnitModel>>> getUnits(String projectId) async {
    try {
      final response = await api.get(EndPoints.kProjectUnits(projectId));
      final apiResponse = ApiResponse.fromJson(response, (data) => data);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to load units'),
        );
      }
      final raw = apiResponse.data;
      final List items = raw is List ? raw : (raw?['items'] as List? ?? []);
      final units = items.map((e) => UnitModel.fromJson(e)).toList();
      return right(units);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> createUnits({
    required String projectId,
    required List<Map<String, dynamic>> units,
  }) async {
    try {
      final response = await api.postList(
        EndPoints.kProjectUnits(projectId),
        body: units,
      );
      final apiResponse = ApiResponse<void>.fromJson(response, null);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to create units'),
        );
      }
      return const Right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, AllocationResultModel>> allocateUnits(
    String projectId,
  ) async {
    try {
      final response = await api.post(
        EndPoints.kProjectUnitsAllocate(projectId),
      );
      final apiResponse = ApiResponse<AllocationResultModel>.fromJson(
        response,
        (data) => AllocationResultModel.fromJson(data as Map<String, dynamic>),
      );
      if (!apiResponse.success || apiResponse.data == null) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to allocate units'),
        );
      }
      return right(apiResponse.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<ShareListingModel>>> getShareListings(
    String projectId,
  ) async {
    try {
      final response = await api.get(
        EndPoints.kProjectShareListings(projectId),
      );
      final apiResponse = ApiResponse.fromJson(response, (data) => data);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to load share listings'),
        );
      }
      final raw = apiResponse.data;
      final List items = raw is List ? raw : (raw?['items'] as List? ?? []);
      final listings = items.map((e) => ShareListingModel.fromJson(e)).toList();
      return right(listings);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> createShareListing({
    required String projectId,
    required int shareCount,
    required double pricePerShareUsd,
  }) async {
    try {
      final response = await api.post(
        EndPoints.kProjectShareListings(projectId),
        body: {'shareCount': shareCount, 'pricePerShareUsd': pricePerShareUsd},
      );
      final apiResponse = ApiResponse<void>.fromJson(response, null);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to list shares'),
        );
      }
      return const Right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, CheckoutSession>> purchaseShareListing({
    required String projectId,
    required String listingId,
  }) async {
    try {
      final response = await api.post(
        EndPoints.kProjectShareListingPurchase(projectId, listingId),
      );
      final apiResponse = ApiResponse<CheckoutSession>.fromJson(
        response,
        (data) => CheckoutSession.fromJson(data as Map<String, dynamic>),
      );
      if (!apiResponse.success || apiResponse.data == null) {
        return left(ServerFailure(apiResponse.message ?? 'Failed to purchase'));
      }
      return right(apiResponse.data!);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> cancelShareListing({
    required String projectId,
    required String listingId,
  }) async {
    try {
      final response = await api.delete(
        EndPoints.kProjectShareListingById(projectId, listingId),
      );
      final apiResponse = ApiResponse<void>.fromJson(response, null);
      if (!apiResponse.success) {
        return left(ServerFailure(apiResponse.message ?? 'Failed to cancel'));
      }
      return const Right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<ExpenseModel>>> getExpenses(
    String projectId,
  ) async {
    try {
      final response = await api.get(EndPoints.kProjectExpenses(projectId));
      final apiResponse = ApiResponse.fromJson(response, (data) => data);
      if (!apiResponse.success) {
        return left(
          ServerFailure(apiResponse.message ?? 'Failed to load expenses'),
        );
      }
      final raw = apiResponse.data;
      final List items = raw is List ? raw : (raw?['items'] as List? ?? []);
      final expenses = items.map((e) => ExpenseModel.fromJson(e)).toList();
      return right(expenses);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> addExpense({
    required String projectId,
    required String category,
    required String description,
    required double amountUsd,
    required DateTime paidAt,
  }) async {
    try {
      final response = await api.post(
        EndPoints.kProjectExpenses(projectId),
        body: {
          'category': category,
          'description': description,
          'amountUsd': amountUsd,
          'paidAt': paidAt.toUtc().toIso8601String(),
        },
      );
    final apiResponse = ApiResponse<void>.fromJson(response, null);

    if (!apiResponse.success) {
      return left(
        ServerFailure(apiResponse.message ?? 'Failed to log expense'),
      );
    }
      return const Right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }
}
