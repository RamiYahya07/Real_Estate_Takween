class PaymentReprocessResult {
  final String? status;
  final String? message;
  final String? checkoutUrl;

  PaymentReprocessResult({this.status, this.message, this.checkoutUrl});

  factory PaymentReprocessResult.fromJson(Map<String, dynamic> json) {
    final payment = json['payment'] as Map<String, dynamic>?;
    return PaymentReprocessResult(
      status: payment?['status']?.toString(),
      message: json['message'] as String?,
      checkoutUrl: json['checkoutUrl'] as String?,
    );
  }

  bool get completed => (status ?? '').toUpperCase() == 'COMPLETED';
}
