import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takween/Features/listings/data/models/my_offer_model.dart';
import 'package:takween/Features/listings/data/repos/listing_repo.dart';
import 'package:takween/Features/listings/presentation/viewmodels/my_offers/my_offers_state.dart';
import 'package:takween/Features/payment/data/repos/payment_repo.dart';

class MyOffersCubit extends Cubit<MyOffersState> {
  final ListingRepo repo;
  final PaymentRepo paymentRepo;

  MyOffersCubit(this.repo, this.paymentRepo) : super(MyOffersInitial());

  List<MyOfferModel> _offers = [];

  Future<void> load() async {
    emit(MyOffersLoading());
    final result = await repo.getMyOffers();
    result.fold(
      (failure) => emit(MyOffersFailure(failure.errMessage)),
      (offers) {
        _offers = offers;
        emit(MyOffersLoaded(offers: List.unmodifiable(_offers)));
      },
    );
  }

  Future<void> refresh() async {
    final result = await repo.getMyOffers();
    result.fold(
      (failure) => emit(MyOffersTransientError(failure.errMessage)),
      (offers) {
        _offers = offers;
        emit(MyOffersLoaded(offers: List.unmodifiable(_offers)));
      },
    );
  }

  Future<void> pay(MyOfferModel offer) async {
    emit(MyOffersLoaded(offers: List.unmodifiable(_offers), payingOfferId: offer.id));

    final listingResult = await repo.getById(offer.listingId);
    final projectId = listingResult.fold<String?>((_) => null, (l) => l.projectId);
    if (projectId == null) {
      emit(MyOffersTransientError('Could not load listing for payment'));
      emit(MyOffersLoaded(offers: List.unmodifiable(_offers)));
      return;
    }

    final checkout = await paymentRepo.createPropertyCheckout(
      projectId: projectId,
      offerId: offer.id,
    );

    emit(MyOffersLoaded(offers: List.unmodifiable(_offers)));
    checkout.fold(
      (failure) => emit(MyOffersTransientError(failure.errMessage)),
      (session) {
        if (session.hasUrl) {
          emit(MyOffersCheckoutReady(
            checkoutUrl: session.checkoutUrl!,
            paymentId: session.paymentId,
          ));
        } else {
          emit(MyOffersTransientError('Could not start checkout'));
        }
      },
    );
  }

  Future<void> confirmPayment(String paymentId) async {
    final result = await paymentRepo.reprocess(paymentId);
    result.fold(
      (failure) => emit(MyOffersTransientError(failure.errMessage)),
      (res) {
        if (res.completed) {
          emit(MyOffersActionSuccess('Payment confirmed — property purchased'));
        } else {
          emit(MyOffersTransientError(
            res.message ?? 'Payment not completed yet. Try again after paying.',
          ));
        }
        refresh();
      },
    );
  }
}
