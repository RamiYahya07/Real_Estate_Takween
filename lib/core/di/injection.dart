import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takween/Features/authentication/data/repos/auth_repo.dart';
import 'package:takween/Features/authentication/data/repos/auth_repo_impl.dart';
import 'package:takween/Features/authentication/presentation/viewmodel/create_account/create_account_cubit.dart';
import 'package:takween/Features/authentication/presentation/viewmodel/sign_in/sign_in_cubit.dart';
import 'package:takween/Features/bid/data/repos/bid_repo.dart';
import 'package:takween/Features/bid/data/repos/bid_repo_impl.dart';
import 'package:takween/Features/bid/data/repos/bidding_realtime_repo.dart';
import 'package:takween/Features/bid/data/repos/bidding_realtime_repo_impl.dart';
import 'package:takween/Features/bid/presentation/viewmodels/bid_action/bid_action_cubit.dart';
import 'package:takween/Features/bid/presentation/viewmodels/get_bid_details/get_bid_details_cubit.dart';
import 'package:takween/Features/bid/presentation/viewmodels/get_bid_summary/get_bid_summary_cubit.dart';
import 'package:takween/Features/bid/presentation/viewmodels/get_bids/get_bids_cubit.dart';
import 'package:takween/Features/bid/presentation/viewmodels/request_bid/request_bid_cubit.dart';
import 'package:takween/Features/chat/data/repos/chat_repo.dart';
import 'package:takween/Features/chat/data/repos/chat_repo_impl.dart';
import 'package:takween/Features/chat/presentation/viewmodels/chat/chat_cubit.dart';
import 'package:takween/Features/contract/data/repos/contract_repo.dart';
import 'package:takween/Features/contract/data/repos/contract_repo_impl.dart';
import 'package:takween/Features/contract/presentation/viewmodels/contract/contract_cubit.dart';
import 'package:takween/Features/contractor/data/repos/contractor_repo.dart';
import 'package:takween/Features/contractor/data/repos/contractor_repo_impl.dart';
import 'package:takween/Features/contractor/presentation/viewmodels/cost_settings/cost_settings_cubit.dart';
import 'package:takween/Features/feasibility/data/repos/feasibility_repo.dart';
import 'package:takween/Features/feasibility/data/repos/feasibility_repo_impl.dart';
import 'package:takween/Features/investments/data/repos/investments_repo.dart';
import 'package:takween/Features/investments/data/repos/investments_repo_impl.dart';
import 'package:takween/Features/investments/presentation/viewmodels/invest/invest_cubit.dart';
import 'package:takween/Features/investments/presentation/viewmodels/investor_review/investor_review_cubit.dart';
import 'package:takween/Features/listings/data/repos/listing_repo.dart';
import 'package:takween/Features/listings/data/repos/listing_repo_impl.dart';
import 'package:takween/Features/listings/presentation/viewmodels/browse_listings/browse_listings_cubit.dart';
import 'package:takween/Features/listings/presentation/viewmodels/create_listing/create_listing_cubit.dart';
import 'package:takween/Features/listings/presentation/viewmodels/listing_details/listing_details_cubit.dart';
import 'package:takween/Features/listings/presentation/viewmodels/listing_offers/listing_offers_cubit.dart';
import 'package:takween/Features/listings/presentation/viewmodels/my_offers/my_offers_cubit.dart';
import 'package:takween/Features/feasibility/presentation/viewmodels/preliminary/preliminary_feasibility_cubit.dart';
import 'package:takween/Features/feasibility/presentation/viewmodels/project_feasibility/project_feasibility_cubit.dart';
import 'package:takween/Features/projects/data/repos/project_repo.dart';
import 'package:takween/Features/projects/data/repos/project_repo_impl.dart';
import 'package:takween/Features/payment/data/repos/payment_repo.dart';
import 'package:takween/Features/payment/data/repos/payment_repo_impl.dart';
import 'package:takween/Features/notifications/data/repos/notification_repo.dart';
import 'package:takween/Features/notifications/data/repos/notification_repo_impl.dart';
import 'package:takween/Features/notifications/data/repos/notification_realtime_repo.dart';
import 'package:takween/Features/notifications/data/repos/notification_realtime_repo_impl.dart';
import 'package:takween/Features/notifications/presentation/viewmodels/notifications_cubit.dart';
import 'package:takween/Features/projects/presentation/viewmodels/get_my_projects/get_my_projects_cubit.dart';
import 'package:takween/Features/projects/presentation/viewmodels/get_project_details/get_project_details_cubit.dart';
import 'package:takween/Features/projects/presentation/viewmodels/expenses/expenses_cubit.dart';
import 'package:takween/Features/projects/presentation/viewmodels/milestones/milestones_cubit.dart';
import 'package:takween/Features/projects/presentation/viewmodels/pending_payment/pending_payment_cubit.dart';
import 'package:takween/Features/projects/presentation/viewmodels/share_listings/share_listings_cubit.dart';
import 'package:takween/Features/projects/presentation/viewmodels/units/units_cubit.dart';
import 'package:takween/Features/maps/data/repos/map_repo.dart';
import 'package:takween/Features/maps/data/repos/map_repo_impl.dart';
import 'package:takween/Features/posts/data/repos/land_post_repo.dart';
import 'package:takween/Features/posts/data/repos/land_post_repo_impl.dart';
import 'package:takween/Features/posts/presentation/viewmodels/create_land_post/create_land_post_cubit.dart';
import 'package:takween/Features/posts/presentation/viewmodels/delete_land_post/delete_land_post_cubit.dart';
import 'package:takween/Features/posts/presentation/viewmodels/edit_land_post/edit_land_post_cubit.dart';
import 'package:takween/Features/posts/presentation/viewmodels/get_land_post/get_land_posts_cubit.dart';
import 'package:takween/Features/posts/presentation/viewmodels/get_land_post_item_details/get_land_post_details_cubit.dart';
import 'package:takween/Features/posts/presentation/viewmodels/get_open_land_post/get_open_land_post_cubit.dart';
import 'package:takween/Features/profile/data/repos/profile_repo.dart';
import 'package:takween/Features/profile/data/repos/profile_repo_impl.dart';
import 'package:takween/Features/profile/presentation/viewmodels/profile_cubit.dart';
import 'package:takween/Features/statistics/data/repos/statistics_repo.dart';
import 'package:takween/Features/statistics/data/repos/statistics_repo_impl.dart';
import 'package:takween/Features/statistics/presentation/viewmodels/dashboard/dashboard_cubit.dart';

import 'package:takween/core/api/api_consumer.dart';
import 'package:takween/core/api/api_conusmer_impl.dart';
import 'package:takween/core/api/dio_client.dart';
import 'package:takween/core/api/server_strings.dart';
import 'package:takween/core/data/secure_storage_service.dart';
import 'package:takween/core/data/shared_prefs_service.dart';
import 'package:takween/core/realtime/hub_client.dart';
import 'package:takween/core/realtime/signalr_hub_client.dart';

const String kChatHubInstance = 'chatHub';
const String kBiddingHubInstance = 'biddingHub';
const String kNotificationHubInstance = 'notificationHub';

final sl = GetIt.instance;
Future<void> initGetIt() async {
  final prefs = await SharedPreferences.getInstance();

  sl.registerLazySingleton<AppPreferences>(() => AppPreferences(prefs));
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  final storage = sl<SecureStorageService>();
  final dio = DioClient.createDio(storage);

  sl.registerLazySingleton<Dio>(() => dio);

  sl.registerLazySingleton<ApiConsumer>(() => ApiConusmerImpl(sl<Dio>()));

  sl.registerLazySingleton<HubClient>(
    () => SignalRHubClient(
      url: EndPoints.kChatHub,
      getToken: () => storage.getToken(),
    ),
    instanceName: kChatHubInstance,
  );
  sl.registerLazySingleton<HubClient>(
    () => SignalRHubClient(
      url: EndPoints.kBiddingHub,
      getToken: () => storage.getToken(),
    ),
    instanceName: kBiddingHubInstance,
  );
  sl.registerLazySingleton<HubClient>(
    () => SignalRHubClient(
      url: EndPoints.kNotificationHub,
      getToken: () => storage.getToken(),
    ),
    instanceName: kNotificationHubInstance,
  );

  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl<ApiConsumer>()));
  sl.registerLazySingleton<MapRepo>(() => MapRepoImpl(sl<ApiConsumer>()));
  sl.registerLazySingleton<LandPostRepo>(
    () => LandPostRepoImpl(sl<ApiConsumer>()),
  );
  sl.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImpl(sl<ApiConsumer>()),
  );
  sl.registerLazySingleton<StatisticsRepo>(
    () => StatisticsRepoImpl(sl<ApiConsumer>()),
  );
  sl.registerLazySingleton<BidRepo>(() => BidRepoImpl(sl<ApiConsumer>()));

  sl.registerLazySingleton<BiddingRealtimeRepo>(
    () => BiddingRealtimeRepoImpl(
      sl<HubClient>(instanceName: kBiddingHubInstance),
    ),
  );
  sl.registerLazySingleton<ChatRepo>(
    () => ChatRepoImpl(
      sl<ApiConsumer>(),
      sl<HubClient>(instanceName: kChatHubInstance),
    ),
  );
  sl.registerLazySingleton<ContractRepo>(
    () => ContractRepoImpl(sl<ApiConsumer>()),
  );
  sl.registerLazySingleton<FeasibilityRepo>(
    () => FeasibilityRepoImpl(sl<ApiConsumer>()),
  );
  sl.registerLazySingleton<ContractorRepo>(
    () => ContractorRepoImpl(sl<ApiConsumer>()),
  );
  sl.registerLazySingleton<ListingRepo>(
    () => ListingRepoImpl(sl<ApiConsumer>()),
  );
  sl.registerLazySingleton<InvestmentsRepo>(
    () => InvestmentsRepoImpl(sl<ApiConsumer>()),
  );
  sl.registerLazySingleton<ProjectRepo>(
    () => ProjectRepoImpl(sl<ApiConsumer>()),
  );
  sl.registerLazySingleton<PaymentRepo>(
    () => PaymentRepoImpl(sl<ApiConsumer>()),
  );
  sl.registerLazySingleton<NotificationRepo>(
    () => NotificationRepoImpl(sl<ApiConsumer>()),
  );
  sl.registerLazySingleton<NotificationRealtimeRepo>(
    () => NotificationRealtimeRepoImpl(
      sl<HubClient>(instanceName: kNotificationHubInstance),
    ),
  );

  sl.registerFactory<CreateAccountCubit>(
    () => CreateAccountCubit(authRepo: sl<AuthRepo>(), storage: storage),
  );
  sl.registerFactory<SignInCubit>(
    () => SignInCubit(
      authRepo: sl<AuthRepo>(),
      storage: storage,
      prefs: sl<AppPreferences>(),
    ),
  );
  sl.registerFactory<GetLandPostsCubit>(
    () => GetLandPostsCubit(sl<LandPostRepo>()),
  );
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl<ProfileRepo>()));
  sl.registerFactory<GetLandPostDetailsCubit>(
    () => GetLandPostDetailsCubit(sl<LandPostRepo>()),
  );
  sl.registerFactory<DeleteLandPostCubit>(
    () => DeleteLandPostCubit(sl<LandPostRepo>()),
  );
  sl.registerFactory<EditLandPostCubit>(
    () => EditLandPostCubit(sl<LandPostRepo>()),
  );
  sl.registerFactory<CreateLandPostCubit>(
    () => CreateLandPostCubit(sl<LandPostRepo>()),
  );
  sl.registerFactory<GetBidsCubit>(
    () => GetBidsCubit(sl<BidRepo>(), sl<BiddingRealtimeRepo>()),
  );
  sl.registerFactory<BidActionCubit>(() => BidActionCubit(sl<BidRepo>()));
  sl.registerFactory<GetBidDetailsCubit>(
    () => GetBidDetailsCubit(sl<BidRepo>()),
  );
  sl.registerFactory<GetBidSummaryCubit>(
    () => GetBidSummaryCubit(sl<BidRepo>()),
  );
  sl.registerFactory<GetOpenLandPostsCubit>(
    () => GetOpenLandPostsCubit(sl<LandPostRepo>()),
  );
  sl.registerFactory<RequestBidCubit>(() => RequestBidCubit(sl<BidRepo>()));

  sl.registerFactory<ChatCubit>(() => ChatCubit(sl<ChatRepo>()));

  sl.registerFactory<ContractCubit>(
    () => ContractCubit(sl<ContractRepo>(), sl<SecureStorageService>()),
  );

  sl.registerFactory<GetMyProjectsCubit>(
    () => GetMyProjectsCubit(sl<ProjectRepo>()),
  );
  sl.registerFactory<GetProjectDetailsCubit>(
    () => GetProjectDetailsCubit(sl<ProjectRepo>()),
  );
  sl.registerFactory<MilestonesCubit>(
    () => MilestonesCubit(sl<ProjectRepo>(), sl<SecureStorageService>()),
  );
  sl.registerFactory<UnitsCubit>(
    () => UnitsCubit(sl<ProjectRepo>(), sl<SecureStorageService>()),
  );
  sl.registerFactory<ShareListingsCubit>(
    () => ShareListingsCubit(
      sl<ProjectRepo>(),
      sl<PaymentRepo>(),
      sl<SecureStorageService>(),
    ),
  );
  sl.registerFactory<ExpensesCubit>(
    () => ExpensesCubit(sl<ProjectRepo>(), sl<SecureStorageService>()),
  );
  sl.registerFactory<PendingPaymentCubit>(
    () => PendingPaymentCubit(sl<PaymentRepo>()),
  );

  sl.registerFactory<PreliminaryFeasibilityCubit>(
    () => PreliminaryFeasibilityCubit(
      sl<FeasibilityRepo>(),
      sl<SecureStorageService>(),
    ),
  );
  sl.registerFactory<ProjectFeasibilityCubit>(
    () => ProjectFeasibilityCubit(
      sl<FeasibilityRepo>(),
      sl<SecureStorageService>(),
    ),
  );

  sl.registerFactory<DashboardCubit>(
    () => DashboardCubit(sl<StatisticsRepo>(), sl<SecureStorageService>()),
  );

  sl.registerFactory<CostSettingsCubit>(
    () => CostSettingsCubit(sl<ContractorRepo>()),
  );

  sl.registerFactory<BrowseListingsCubit>(
    () => BrowseListingsCubit(sl<ListingRepo>()),
  );
  sl.registerFactory<ListingDetailsCubit>(
    () => ListingDetailsCubit(sl<ListingRepo>(), sl<SecureStorageService>()),
  );
  sl.registerFactory<ListingOffersCubit>(
    () => ListingOffersCubit(sl<ListingRepo>()),
  );
  sl.registerFactory<MyOffersCubit>(
    () => MyOffersCubit(sl<ListingRepo>(), sl<PaymentRepo>()),
  );
 sl.registerFactory<NotificationsCubit>(
  () => NotificationsCubit(
    sl<NotificationRepo>(),
    sl<NotificationRealtimeRepo>(),
  ),
);
  sl.registerFactory<CreateListingCubit>(
    () => CreateListingCubit(sl<ListingRepo>()),
  );
  sl.registerFactory<InvestCubit>(
    () => InvestCubit(sl<InvestmentsRepo>(), sl<PaymentRepo>()),
  );
  sl.registerFactory<InvestorReviewCubit>(
    () => InvestorReviewCubit(sl<InvestmentsRepo>()),
  );
}
