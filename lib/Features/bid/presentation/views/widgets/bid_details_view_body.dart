import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/bid/presentation/viewmodels/get_bid_details/get_bid_details_cubit.dart';
import 'package:takween/Features/bid/presentation/viewmodels/get_bid_details/get_bid_details_state.dart';

class BidDetailsViewBody extends StatefulWidget {
  final String bidId;

  const BidDetailsViewBody({super.key, required this.bidId});

  @override
  State<BidDetailsViewBody> createState() => _BidDetailsViewBodyState();
}

class _BidDetailsViewBodyState extends State<BidDetailsViewBody> {
  @override
  void initState() {
    super.initState();
    context.read<GetBidDetailsCubit>().getBidDetails(widget.bidId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetBidDetailsCubit, GetBidDetailsState>(
      builder: (context, state) {
        if (state is GetBidDetailsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetBidDetailsFailureState) {
          return Center(child: Text(state.message));
        }

        if (state is GetBidDetailsSuccessState) {
          final bid = state.data;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                /// 🔷 HEADER CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        child: Text(bid.contractorName[0].toUpperCase()),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bid.contractorName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(bid.investmentType),
                          ],
                        ),
                      ),

                      _statusBadge(bid.status),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// 📊 INFO CARDS
                Row(
                  children: [
                    Expanded(
                      child: _infoCard(
                        title: "Cost",
                        value: "\$${bid.estimatedConstructionCostUsd}",
                        icon: Icons.attach_money,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _infoCard(
                        title: "Timeline",
                        value: "${bid.estimatedTimelineMonths} m",
                        icon: Icons.timer,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                if (bid.offerPriceUsd != null)
                  _infoCard(
                    title: "Offer Price",
                    value: "\$${bid.offerPriceUsd}",
                    icon: Icons.local_offer,
                    color: Colors.blue,
                  ),

                const SizedBox(height: 16),

                /// 🏗 DETAILS
                _sectionCard(
                  title: "Project Details",
                  children: [
                    _rowItem("Floors", bid.proposedFloors.toString()),
                    _rowItem("Finish Tier", bid.finishTier),
                    _rowItem(
                      "Landowner Share",
                      "${bid.landownerSharePercent}%",
                    ),
                    _rowItem(
                      "Contractor Share",
                      "${bid.contractorSharePercent}%",
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// 📝 DESCRIPTION
                _sectionCard(
                  title: "Proposal",
                  children: [_textBlock(bid.proposedApproach)],
                ),

                const SizedBox(height: 16),

                _sectionCard(title: "Notes", children: [_textBlock(bid.notes)]),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

Widget _infoCard({
  required String title,
  required String value,
  required IconData icon,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    ),
  );
}

Widget _sectionCard({required String title, required List<Widget> children}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        ...children,
      ],
    ),
  );
}

Widget _rowItem(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text("$title: "),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

Widget _textBlock(String text) {
  return Text(text, style: const TextStyle(height: 1.4));
}

Widget _statusBadge(String status) {
  Color color;

  switch (status) {
    case "PENDING":
      color = Colors.orange;
      break;
    case "ACCEPTED":
      color = Colors.green;
      break;
    case "REJECTED":
      color = Colors.red;
      break;
    default:
      color = Colors.grey;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      status,
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    ),
  );
}
