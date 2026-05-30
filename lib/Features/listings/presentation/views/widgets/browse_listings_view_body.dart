import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:takween/Features/listings/presentation/viewmodels/browse_listings/browse_listings_cubit.dart';
import 'package:takween/Features/listings/presentation/viewmodels/browse_listings/browse_listings_state.dart';
import 'package:takween/Features/listings/presentation/views/widgets/listing_card.dart';
import 'package:takween/core/router/routes.dart';
import 'package:takween/core/theme/colors.dart';

class BrowseListingsViewBody extends StatefulWidget {
  const BrowseListingsViewBody({super.key});

  @override
  State<BrowseListingsViewBody> createState() => _BrowseListingsViewBodyState();
}

class _BrowseListingsViewBodyState extends State<BrowseListingsViewBody> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<BrowseListingsCubit>().load();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      context.read<BrowseListingsCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrowseListingsCubit, BrowseListingsState>(
      builder: (context, state) {
        if (state is BrowseListingsLoadingState ||
            state is BrowseListingsInitialState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is BrowseListingsFailureState) {
          return _ErrorView(
            message: state.message,
            onRetry: () => context.read<BrowseListingsCubit>().refresh(),
          );
        }
        if (state is BrowseListingsSuccessState) {
          if (state.listings.isEmpty) {
            return _EmptyView(
              onRefresh: () => context.read<BrowseListingsCubit>().refresh(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<BrowseListingsCubit>().refresh(),
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount:
                  state.listings.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.listings.length) {
                  return Padding(
                    padding: EdgeInsets.all(12.w),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final l = state.listings[index];
                return ListingCard(
                  listing: l,
                  onTap: () => context.push(
                    Routes.listingDetails,
                    extra: l.id,
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _EmptyView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  const _EmptyView({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 100.h),
          Center(
            child: FaIcon(
              FontAwesomeIcons.house,
              size: 56.sp,
              color: AppColors.primary.withValues(alpha: 0.4),
            ),
          ),
          SizedBox(height: 14.h),
          Center(
            child: Text(
              'No listings yet',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Text(
                'Properties from completed projects will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textTertiaryLight,
                ),
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
