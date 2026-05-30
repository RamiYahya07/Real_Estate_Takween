class CheckoutSession {
  final String paymentId;
  final String? checkoutUrl;

  CheckoutSession({required this.paymentId, this.checkoutUrl});

  factory CheckoutSession.fromJson(Map<String, dynamic> json) {
    return CheckoutSession(
      paymentId: (json['paymentId'] ?? json['id'])?.toString() ?? '',
      checkoutUrl: (json['checkoutUrl'] ?? json['sessionUrl']) as String?,
    );
  }

  bool get hasUrl => checkoutUrl != null && checkoutUrl!.isNotEmpty;
}
