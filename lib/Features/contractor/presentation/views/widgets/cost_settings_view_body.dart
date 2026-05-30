import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/contractor/data/models/cost_rates_model.dart';
import 'package:takween/Features/contractor/presentation/viewmodels/cost_settings/cost_settings_cubit.dart';
import 'package:takween/Features/contractor/presentation/viewmodels/cost_settings/cost_settings_state.dart';
import 'package:takween/core/theme/colors.dart';
import 'package:takween/core/utils/extensions.dart';
import 'package:takween/core/widgets/custom_button.dart';
import 'package:takween/core/widgets/custom_text_form_field.dart';

class CostSettingsViewBody extends StatefulWidget {
  const CostSettingsViewBody({super.key});

  @override
  State<CostSettingsViewBody> createState() => _CostSettingsViewBodyState();
}

class _CostSettingsViewBodyState extends State<CostSettingsViewBody> {
  final _formKey = GlobalKey<FormState>();

  final _controllers = <String, TextEditingController>{
    for (final k in _allFields) k: TextEditingController(),
  };
  String? _populatedFor;

  static const _allFields = [
    'cementPerTonUsd',
    'steelPerTonUsd',
    'concretePerCubicMeterUsd',
    'bricksPerThousandUsd',
    'sandPerCubicMeterUsd',
    'gravelPerCubicMeterUsd',
    'skilledLaborPerDayUsd',
    'unskilledLaborPerDayUsd',
    'electricalLaborPerDayUsd',
    'plumbingLaborPerDayUsd',
    'cranePerMonthUsd',
    'excavatorPerMonthUsd',
    'mixerPerMonthUsd',
    'basicFinishPerSqmUsd',
    'standardFinishPerSqmUsd',
    'premiumFinishPerSqmUsd',
  ];

  @override
  void initState() {
    super.initState();
    context.read<CostSettingsCubit>().load();
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _populateFromRates(CostRatesModel r) {
    _controllers['cementPerTonUsd']!.text = _fmt(r.cementPerTonUsd);
    _controllers['steelPerTonUsd']!.text = _fmt(r.steelPerTonUsd);
    _controllers['concretePerCubicMeterUsd']!.text =
        _fmt(r.concretePerCubicMeterUsd);
    _controllers['bricksPerThousandUsd']!.text = _fmt(r.bricksPerThousandUsd);
    _controllers['sandPerCubicMeterUsd']!.text = _fmt(r.sandPerCubicMeterUsd);
    _controllers['gravelPerCubicMeterUsd']!.text =
        _fmt(r.gravelPerCubicMeterUsd);
    _controllers['skilledLaborPerDayUsd']!.text =
        _fmt(r.skilledLaborPerDayUsd);
    _controllers['unskilledLaborPerDayUsd']!.text =
        _fmt(r.unskilledLaborPerDayUsd);
    _controllers['electricalLaborPerDayUsd']!.text =
        _fmt(r.electricalLaborPerDayUsd);
    _controllers['plumbingLaborPerDayUsd']!.text =
        _fmt(r.plumbingLaborPerDayUsd);
    _controllers['cranePerMonthUsd']!.text = _fmt(r.cranePerMonthUsd);
    _controllers['excavatorPerMonthUsd']!.text = _fmt(r.excavatorPerMonthUsd);
    _controllers['mixerPerMonthUsd']!.text = _fmt(r.mixerPerMonthUsd);
    _controllers['basicFinishPerSqmUsd']!.text = _fmt(r.basicFinishPerSqmUsd);
    _controllers['standardFinishPerSqmUsd']!.text =
        _fmt(r.standardFinishPerSqmUsd);
    _controllers['premiumFinishPerSqmUsd']!.text =
        _fmt(r.premiumFinishPerSqmUsd);
  }

  String _fmt(double v) => v == 0 ? '' : v.toString();

  double _parse(String key) {
    final raw = _controllers[key]!.text.trim();
    if (raw.isEmpty) return 0;
    return double.tryParse(raw) ?? 0;
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final rates = CostRatesModel(
      cementPerTonUsd: _parse('cementPerTonUsd'),
      steelPerTonUsd: _parse('steelPerTonUsd'),
      concretePerCubicMeterUsd: _parse('concretePerCubicMeterUsd'),
      bricksPerThousandUsd: _parse('bricksPerThousandUsd'),
      sandPerCubicMeterUsd: _parse('sandPerCubicMeterUsd'),
      gravelPerCubicMeterUsd: _parse('gravelPerCubicMeterUsd'),
      skilledLaborPerDayUsd: _parse('skilledLaborPerDayUsd'),
      unskilledLaborPerDayUsd: _parse('unskilledLaborPerDayUsd'),
      electricalLaborPerDayUsd: _parse('electricalLaborPerDayUsd'),
      plumbingLaborPerDayUsd: _parse('plumbingLaborPerDayUsd'),
      cranePerMonthUsd: _parse('cranePerMonthUsd'),
      excavatorPerMonthUsd: _parse('excavatorPerMonthUsd'),
      mixerPerMonthUsd: _parse('mixerPerMonthUsd'),
      basicFinishPerSqmUsd: _parse('basicFinishPerSqmUsd'),
      standardFinishPerSqmUsd: _parse('standardFinishPerSqmUsd'),
      premiumFinishPerSqmUsd: _parse('premiumFinishPerSqmUsd'),
    );
    context.read<CostSettingsCubit>().save(rates);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CostSettingsCubit, CostSettingsState>(
      listener: (context, state) {
        if (state is CostSettingsTransientError) {
          context.showErrorSnackBar(state.message);
        }
        if (state is CostSettingsSavedState) {
          context.showSuccessSnackBar('Cost settings saved');
        }
        if (state is CostSettingsLoadedState) {
          final stamp =
              state.settings.updatedAt.microsecondsSinceEpoch.toString();
          if (_populatedFor != stamp) {
            _populateFromRates(state.settings.rates);
            _populatedFor = stamp;
          }
        }
      },
      buildWhen: (prev, curr) =>
          curr is! CostSettingsTransientError &&
          curr is! CostSettingsSavedState,
      builder: (context, state) {
        if (state is CostSettingsInitialState ||
            state is CostSettingsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CostSettingsFailureState) {
          return _ErrorView(
            message: state.message,
            onRetry: () => context.read<CostSettingsCubit>().load(),
          );
        }
        if (state is CostSettingsLoadedState) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              children: [
                _HeaderHint(updatedAt: state.settings.updatedAt),
                SizedBox(height: 14.h),
                _SectionHeader(
                  icon: FontAwesomeIcons.cubes,
                  title: 'Materials',
                ),
                SizedBox(height: 8.h),
                _rateField('Cement (per ton)', 'cementPerTonUsd'),
                _rateField('Steel (per ton)', 'steelPerTonUsd'),
                _rateField('Concrete (per m³)', 'concretePerCubicMeterUsd'),
                _rateField('Bricks (per 1,000)', 'bricksPerThousandUsd'),
                _rateField('Sand (per m³)', 'sandPerCubicMeterUsd'),
                _rateField('Gravel (per m³)', 'gravelPerCubicMeterUsd'),

                SizedBox(height: 8.h),
                _SectionHeader(
                  icon: FontAwesomeIcons.peopleGroup,
                  title: 'Labor',
                ),
                SizedBox(height: 8.h),
                _rateField('Skilled (per day)', 'skilledLaborPerDayUsd'),
                _rateField('Unskilled (per day)', 'unskilledLaborPerDayUsd'),
                _rateField('Electrical (per day)', 'electricalLaborPerDayUsd'),
                _rateField('Plumbing (per day)', 'plumbingLaborPerDayUsd'),

                SizedBox(height: 8.h),
                _SectionHeader(
                  icon: FontAwesomeIcons.truck,
                  title: 'Equipment',
                ),
                SizedBox(height: 8.h),
                _rateField('Crane (per month)', 'cranePerMonthUsd'),
                _rateField('Excavator (per month)', 'excavatorPerMonthUsd'),
                _rateField('Mixer (per month)', 'mixerPerMonthUsd'),

                SizedBox(height: 8.h),
                _SectionHeader(
                  icon: FontAwesomeIcons.paintRoller,
                  title: 'Finishing',
                ),
                SizedBox(height: 8.h),
                _rateField('Basic finish (per m²)', 'basicFinishPerSqmUsd'),
                _rateField('Standard finish (per m²)', 'standardFinishPerSqmUsd'),
                _rateField('Premium finish (per m²)', 'premiumFinishPerSqmUsd'),

                SizedBox(height: 14.h),
                state.isSaving
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : CustomButton(
                        title: 'Save Cost Settings',
                        icon: Icons.save_outlined,
                        color: AppColors.primary,
                        onTap: _submit,
                      ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _rateField(String label, String key) {
    return CustomTextFormField(
      label: label,
      hintText: '0',
      controller: _controllers[key],
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return null;
        final n = double.tryParse(value.trim());
        if (n == null || n < 0) return 'Invalid number';
        return null;
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final FaIconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(icon, size: 14.sp, color: AppColors.primary),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _HeaderHint extends StatelessWidget {
  final DateTime updatedAt;

  const _HeaderHint({required this.updatedAt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryContainerLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.circleInfo,
            size: 14.sp,
            color: AppColors.primary,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Set your unit rates. They drive cost estimates and detailed '
              'feasibility studies. Leave a field blank to keep it 0.',
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.primary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 40.sp,
              color: AppColors.error,
            ),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp),
            ),
            SizedBox(height: 16.h),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
