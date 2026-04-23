import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/Models/bookingModel.dart';

class BookingService {
  final SupabaseClient _client;

  BookingService(this._client);

  /// Fetch all bookings for a specific user
  Future<List<BookingModel>> getBookingsByUser(String userId) async {
    final response = await _client
        .from('bookings')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Fetch all bookings (admin overview)
  Future<List<BookingModel>> getAllBookings() async {
    final response = await _client
        .from('bookings')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Delete a booking by id
  Future<void> deleteBooking(String bookingId) async {
    await _client.from('bookings').delete().eq('id', bookingId);
  }

  /// Update booking status
  Future<void> updateBookingStatus(
      String bookingId, String newStatus) async {
    await _client
        .from('bookings')
        .update({'booking_status': newStatus})
        .eq('id', bookingId);
  }
}