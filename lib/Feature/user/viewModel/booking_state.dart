import '../../../core/Models/bookingModel.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<BookingModel> bookings;
  final String activeStatusFilter;

  BookingLoaded({
    required this.bookings,
    this.activeStatusFilter = 'All',
  });

  List<BookingModel> get filtered {
    if (activeStatusFilter == 'All') return bookings;
    return bookings
        .where((b) =>
    b.bookingStatus.toLowerCase() ==
        activeStatusFilter.toLowerCase())
        .toList();
  }

  BookingLoaded copyWith({
    List<BookingModel>? bookings,
    String? activeStatusFilter,
  }) {
    return BookingLoaded(
      bookings: bookings ?? this.bookings,
      activeStatusFilter: activeStatusFilter ?? this.activeStatusFilter,
    );
  }
}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}

class BookingActionSuccess extends BookingState {
  final String message;
  BookingActionSuccess(this.message);
}