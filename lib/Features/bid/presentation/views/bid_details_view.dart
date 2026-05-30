import 'package:flutter/material.dart';
import 'package:takween/Features/bid/presentation/views/widgets/bid_details_view_body.dart';

class BidDetailsView extends StatelessWidget {
  final String bidId;

  const BidDetailsView({super.key, required this.bidId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bid Details")),
      body: BidDetailsViewBody(bidId: bidId),
    );
  }
}