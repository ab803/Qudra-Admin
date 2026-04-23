class BookingModel {
  final String id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String userId;
  final String? institutionId;
  final String? serviceId;
  final String? requestedDate;
  final String? requestedTime;
  final String? notes;
  final double? amount;
  final String bookingStatus;
  final String? paymentMethod;
  final String? paymentStatus;
  final String? paymobOrderId;
  final String? paymobIntentionId;
  final DateTime? confirmedAt;
  final DateTime? cancelledAt;

  const BookingModel({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    required this.userId,
    this.institutionId,
    this.serviceId,
    this.requestedDate,
    this.requestedTime,
    this.notes,
    this.amount,
    required this.bookingStatus,
    this.paymentMethod,
    this.paymentStatus,
    this.paymobOrderId,
    this.paymobIntentionId,
    this.confirmedAt,
    this.cancelledAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      userId: json['user_id'] as String,
      institutionId: json['institution_id'] as String?,
      serviceId: json['service_id'] as String?,
      requestedDate: json['requested_date'] as String?,
      requestedTime: json['requested_time'] as String?,
      notes: json['notes'] as String?,
      amount: json['amount'] != null
          ? (json['amount'] as num).toDouble()
          : null,
      bookingStatus: json['booking_status'] as String? ?? 'unknown',
      paymentMethod: json['payment_method'] as String?,
      paymentStatus: json['payment_status'] as String?,
      paymobOrderId: json['paymob_order_id'] as String?,
      paymobIntentionId: json['paymob_intention_id'] as String?,
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.parse(json['confirmed_at'] as String)
          : null,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'] as String)
          : null,
    );
  }

  String get formattedDate {
    if (requestedDate == null) return '—';
    try {
      final d = DateTime.parse(requestedDate!);
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return requestedDate!;
    }
  }

  String get formattedTime {
    if (requestedTime == null) return '—';
    // Remove seconds if present "HH:mm:ss" → "HH:mm"
    return requestedTime!.length > 5
        ? requestedTime!.substring(0, 5)
        : requestedTime!;
  }

  String get formattedAmount =>
      amount != null ? 'EGP ${amount!.toStringAsFixed(0)}' : '—';

  String get shortId => id.length > 8 ? '#${id.substring(0, 8)}' : '#$id';
}