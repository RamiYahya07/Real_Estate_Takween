// const kIp = '192.168.1.5';
// const kIp = '192.168.1.8';
// const kIp = '10.102.167.152';
const kIp = '192.168.1.3';
// const kIp = '172.20.10.2';
const kBaseUrl = 'https://$kIp:7069';
const kBaseUrlhttp = 'http://$kIp:5238';
const kApi = '$kBaseUrl/api';
const kPlaceBaseUrl = "https://maps.googleapis  .com/maps/api/place";

class EndPoints {
  //auth
  static const String kAuth = '$kApi/Auth';

  static const String kLogin = '$kAuth/login';
  static const String kRegister = '$kAuth/register';
  static const String kRefershToken = '$kAuth/refresh-token';
  //profile
  static const String kProfile = '$kAuth/profile';
  static const String kUploadProfilePicture = '$kProfile/avatar';

  // bid
  static const String kBid = '$kApi/Bid';
  static const String kBidLandPost = '$kBid/land-post';

  static const String kMuqasama = '$kBid/muqasama';
  static const String kJointInvestment = '$kBid/joint-investment';
  static const String kDirectSale = '$kBid/direct-sale';
  static const String kShareOffering = '$kBid/share-offering';

  //landPost
  static const String kLandPost = '$kApi/LandPost';
  static const String kMyPosts = '$kLandPost/my-posts';
  static const String kDocuments = '/documents';
  static const String kSubmit = '/submit';

  //stats
  static const String kStats = '$kApi/stats';
  static const String kContractorDashboard = '$kStats/contractor';
  static const String kLandOwnerDashboard = '$kStats/landowner';
  static const String kStatsProjects = '$kStats/projects';
  static const String kStatsShares = '$kStats/shares';
  static const String kStatsListing = '$kStats/listings';
  static const String kStatsBuyer = '$kStats/buyer';

  //investor requests
  static String kProjectInvestorRequests(String projectId) =>
      '$kProject/$projectId/investor-requests';
  static String kProjectInvestorRequestById(String projectId, String requestId) =>
      '$kProject/$projectId/investor-requests/$requestId';
  static const String kOpenInvestments = '$kProject/open-investments';
  static const String kMyInvestments = '$kProject/my-investments';

  //hubs
  static const String kBiddingHub = '$kBaseUrl/Hubs/bidding';
  static const String kChatHub = '$kBaseUrl/Hubs/chat';
  static const String kNotificationHub = '$kBaseUrl/Hubs/notification';

  //notifications
  static const String kNotifications = '$kApi/Notification';
  static const String kNotificationsRead = '$kNotifications/read';
  static const String kNotificationsMarkAllRead = '$kNotifications/mark-all-read';

  //chat
  static String kProjectMessages(String projectId) =>
      '$kApi/project/$projectId/messages';

  //contract
  static String kProjectContract(String projectId) =>
      '$kApi/project/$projectId/contracts';
  static String kProjectContractSign(String projectId) =>
      '${kProjectContract(projectId)}/sign';

  //projects
  static const String kProject = '$kApi/project';
  static const String kMyProjects = '$kProject/my-projects';
  static String kProjectById(String projectId) => '$kProject/$projectId';

  //milestones
  static String kProjectMilestones(String projectId) =>
      '$kProject/$projectId/milestones';
  static String kProjectMilestoneStatus(String projectId, String milestoneId) =>
      '$kProject/$projectId/milestones/$milestoneId/status';

  //units
  static String kProjectUnits(String projectId) => '$kProject/$projectId/units';
  static String kProjectUnitsAllocate(String projectId) =>
      '$kProject/$projectId/units/allocate';

  //feasibility
  static const String _emptyGuid = '00000000-0000-0000-0000-000000000000';
  static String kPreliminaryFeasibility(String landPostId) =>
      '$kProject/$_emptyGuid/feasibility/preliminary/$landPostId';
  static String kDetailedFeasibility(String projectId) =>
      '$kProject/$projectId/feasibility/detailed';
  static String kCashflowFeasibility(String projectId) =>
      '$kProject/$projectId/feasibility/cashflow';

  //expenses
  static String kProjectExpenses(String projectId) =>
      '$kProject/$projectId/expenses';

  //contractor cost settings
  static const String kContractor = '$kApi/Contractor';
  static const String kCostSettings = '$kContractor/cost-settings';
  static String kContractorEstimate(String projectId) =>
      '$kContractor/estimate/$projectId';

  //property listings
  static const String kListing = '$kApi/Listing';
  static const String kListingMyOffers = '$kListing/my-offers';
  static String kListingById(String id) => '$kListing/$id';
  static String kListingOffer(String id) => '$kListing/$id/offer';
  static String kListingOffers(String id) => '$kListing/$id/offers';
  static String kListingReviewOffer(String id, String offerId) =>
      '$kListing/$id/offers/$offerId';

  //payment
  static const String kPaymentCheckout = '$kApi/payment/checkout';
  static String kPaymentInit(String paymentId) =>
      '$kApi/payment/$paymentId/init';
  static String kPaymentReprocess(String paymentId) =>
      '$kApi/payment/$paymentId/reprocess';

  //share listings
  static String kProjectShareListings(String projectId) =>
      '$kProject/$projectId/share-listings';
  static String kProjectShareListingPurchase(
    String projectId,
    String listingId,
  ) => '$kProject/$projectId/share-listings/$listingId/purchase';
  static String kProjectShareListingById(String projectId, String listingId) =>
      '$kProject/$projectId/share-listings/$listingId';
}
