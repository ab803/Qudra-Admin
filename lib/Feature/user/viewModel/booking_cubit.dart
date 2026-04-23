import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/Models/bookingModel.dart';
import '../repo/bookingRepo.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository _repository;

  // Keep a master copy for filter resets
  List<BookingModel> _allBookings = [];

  BookingCubit(this._repository) : super(BookingInitial());

  /// Load bookings for a specific user
  Future<void> loadUserBookings(String userId) async {
    emit(BookingLoading());
    try {
      _allBookings = await _repository.getBookingsByUser(userId);
      emit(BookingLoaded(bookings: _allBookings));
    } catch (e) {
      emit(BookingError('Failed to load bookings: ${e.toString()}'));
    }
  }

  /// Load all bookings (admin overview)
  Future<void> loadAllBookings() async {
    emit(BookingLoading());
    try {
      _allBookings = await _repository.getAllBookings();
      emit(BookingLoaded(bookings: _allBookings));
    } catch (e) {
      emit(BookingError('Failed to load bookings: ${e.toString()}'));
    }
  }

  void filterByStatus(String status) {
    final current = state;
    if (current is BookingLoaded) {
      emit(current.copyWith(activeStatusFilter: status));
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    try {
      await _repository.deleteBooking(bookingId);
      _allBookings.removeWhere((b) => b.id == bookingId);
      final current = state;
      if (current is BookingLoaded) {
        emit(BookingActionSuccess('Booking deleted successfully'));
        emit(current.copyWith(bookings: List.from(_allBookings)));
      }
    } catch (e) {
      emit(BookingError('Failed to delete booking: ${e.toString()}'));
    }
  }

  Future<void> updateStatus(String bookingId, String newStatus) async {
    try {
      await _repository.updateBookingStatus(bookingId, newStatus);
      final idx = _allBookings.indexWhere((b) => b.id == bookingId);
      if (idx != -1) {
        // Rebuild list with updated status using copyWith-style workaround
        _allBookings = List.from(_allBookings);
      }
      final current = state;
      if (current is BookingLoaded) {
        emit(BookingActionSuccess('Status updated to $newStatus'));
        // Reload to reflect change
        await _repository
            .getBookingsByUser(_allBookings.isNotEmpty
            ? _allBookings.first.userId
            : '')
            .then((fresh) {
          _allBookings = fresh;
          emit(current.copyWith(bookings: fresh));
        });
      }
    } catch (e) {
      emit(BookingError('Failed to update status: ${e.toString()}'));
    }
  }
}