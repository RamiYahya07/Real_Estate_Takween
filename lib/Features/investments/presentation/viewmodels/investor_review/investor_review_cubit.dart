import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/investments/data/models/investor_request_model.dart';
import 'package:takween/Features/investments/data/repos/investments_repo.dart';
import 'package:takween/Features/investments/presentation/viewmodels/investor_review/investor_review_state.dart';

class InvestorReviewCubit extends Cubit<InvestorReviewState> {
  final InvestmentsRepo repo;
  InvestorReviewCubit(this.repo) : super(InvestorReviewInitial());

  List<InvestorRequestModel> _requests = [];

  Future<void> load(String projectId) async {
    emit(InvestorReviewLoading());
    final res = await repo.getProjectRequests(projectId);
    res.fold(
      (f) => emit(InvestorReviewFailure(f.errMessage)),
      (list) {
        _requests = list;
        emit(InvestorReviewLoaded(requests: List.unmodifiable(_requests)));
      },
    );
  }

  Future<void> refresh(String projectId) async {
    final res = await repo.getProjectRequests(projectId);
    res.fold(
      (f) => emit(InvestorReviewTransientError(f.errMessage)),
      (list) {
        _requests = list;
        emit(InvestorReviewLoaded(requests: List.unmodifiable(_requests)));
      },
    );
  }

  Future<void> review({
    required String projectId,
    required String requestId,
    required bool approve,
  }) async {
    if (state is InvestorReviewLoaded) {
      emit((state as InvestorReviewLoaded)
          .copyWith(processingRequestId: requestId));
    }

    final res = await repo.review(
      projectId: projectId,
      requestId: requestId,
      approve: approve,
    );

    res.fold(
      (f) {
        emit(InvestorReviewTransientError(f.errMessage));
        if (state is InvestorReviewLoaded) {
          emit((state as InvestorReviewLoaded).copyWith(clearProcessing: true));
        }
      },
      (msg) {
        emit(InvestorReviewActionSuccess(msg));
        refresh(projectId);
      },
    );
  }
}
