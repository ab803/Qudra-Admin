import '../../../core/Models/bookingModel.dart';
import '../../../core/Services/Supabase/bookingService.dart';


class BookingRepository {
  final BookingService _service;

  BookingRepository(this._service);

  Future<List<BookingModel>> getBookingsByUser(String userId) =>
      _service.getBookingsByUser(userId);

  Future<List<BookingModel>> getAllBookings() =>
      _service.getAllBookings();

  Future<void> deleteBooking(String bookingId) =>
      _service.deleteBooking(bookingId);

  Future<void> updateBookingStatus(String bookingId, String newStatus) =>
      _service.updateBookingStatus(bookingId, newStatus);
}