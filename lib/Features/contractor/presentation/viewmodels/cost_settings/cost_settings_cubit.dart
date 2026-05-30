import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/contractor/data/models/cost_rates_model.dart';
import 'package:takween/Features/contractor/data/models/cost_settings_model.dart';
import 'package:takween/Features/contractor/data/repos/contractor_repo.dart';
import 'package:takween/Features/contractor/presentation/viewmodels/cost_settings/cost_settings_state.dart';

class CostSettingsCubit extends Cubit<CostSettingsState> {
  final ContractorRepo repo;

  CostSettingsCubit(this.repo) : super(CostSettingsInitialState());

  CostSettingsModel? _current;
  bool _isSaving = false;

  Future<void> load() async {
    emit(CostSettingsLoadingState());
    final result = await repo.getCostSettings();
    result.fold(
      (failure) => emit(CostSettingsFailureState(failure.errMessage)),
      (settings) {
        _current = settings;
        _emitLoaded();
      },
    );
  }

  Future<void> save(CostRatesModel rates) async {
    if (_current == null) return;
    _isSaving = true;
    _emitLoaded();

    final result = await repo.updateCostSettings(rates);
    _isSaving = false;
    result.fold(
      (failure) {
        emit(CostSettingsTransientError(failure.errMessage));
        _emitLoaded();
      },
      (_) {
        _current = CostSettingsModel(rates: rates, updatedAt: DateTime.now());
        emit(CostSettingsSavedState());
        _emitLoaded();
      },
    );
  }

  void _emitLoaded() {
    if (_current == null) return;
    emit(CostSettingsLoadedState(settings: _current!, isSaving: _isSaving));
  }
}
