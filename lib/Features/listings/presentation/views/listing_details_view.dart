import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/listings/presentation/viewmodels/listing_details/listing_details_cubit.dart';
import 'package:takween/Features/listings/presentation/views/widgets/listing_details_view_body.dart';
import 'package:takween/core/di/injection.dart';

class ListingDetailsView extends StatelessWidget {
  final String listingId;

  const ListingDetailsView({super.key, required this.listingId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ListingDetailsCubit>()..load(listingId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Listing')),
        body: ListingDetailsViewBody(listingId: listingId),
      ),
    );
  }
}
