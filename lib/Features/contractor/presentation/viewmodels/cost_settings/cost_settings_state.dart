import 'package:equatable/equatable.dart';
import 'package:takween/Features/contractor/data/models/cost_settings_model.dart';

abstract class CostSettingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CostSettingsInitialState extends CostSettingsState {}

class CostSettingsLoadingState extends CostSettingsState {}

class CostSettingsLoadedState extends CostSettingsState {
  final CostSettingsModel settings;
  final bool isSaving;

  CostSettingsLoadedState({required this.settings, this.isSaving = false});

  CostSettingsLoadedState copyWith({
    CostSettingsModel? settings,
    bool? isSaving,
  }) {
    return CostSettingsLoadedState(
      settings: settings ?? this.settings,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [settings, isSaving];
}

class CostSettingsFailureState extends CostSettingsState {
  final String message;
  CostSettingsFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

class CostSettingsTransientError extends CostSettingsState {
  final String message;
  CostSettingsTransientError(this.message);

  @override
  List<Object?> get props => [message, DateTime.now().microsecondsSinceEpoch];
}

class CostSettingsSavedState extends CostSettingsState {
  CostSettingsSavedState();

  @override
  List<Object?> get props => [DateTime.now().microsecondsSinceEpoch];
}
