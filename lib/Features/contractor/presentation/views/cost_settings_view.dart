import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/contractor/presentation/viewmodels/cost_settings/cost_settings_cubit.dart';
import 'package:takween/Features/contractor/presentation/views/widgets/cost_settings_view_body.dart';
import 'package:takween/core/di/injection.dart';

class CostSettingsView extends StatelessWidget {
  const CostSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CostSettingsCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Cost Settings')),
        body: const CostSettingsViewBody(),
      ),
    );
  }
}
