import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/listings/presentation/viewmodels/browse_listings/browse_listings_cubit.dart';
import 'package:takween/Features/listings/presentation/views/widgets/browse_listings_view_body.dart';
import 'package:takween/core/di/injection.dart';

class BrowseListingsView extends StatelessWidget {
  const BrowseListingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BrowseListingsCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Property Listings')),
        body: const BrowseListingsViewBody(),
      ),
    );
  }
}
