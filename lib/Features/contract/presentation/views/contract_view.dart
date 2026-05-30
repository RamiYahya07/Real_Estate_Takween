import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:takween/Features/contract/presentation/viewmodels/contract/contract_cubit.dart';
import 'package:takween/Features/contract/presentation/views/widgets/contract_view_body.dart';

class ContractView extends StatelessWidget {
  final String projectId;
  final String projectTitle;

  const ContractView({
    super.key,
    required this.projectId,
    required this.projectTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Contract'),
            Text(
              projectTitle,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 18),
            onPressed: () =>
                context.read<ContractCubit>().refresh(projectId),
          ),
        ],
      ),
      body: ContractViewBody(projectId: projectId),
    );
  }
}
