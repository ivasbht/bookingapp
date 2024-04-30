import 'package:bookingapp/model/booking_model/booking_model.dart';
import 'package:bookingapp/service/booking_service/booking_service.dart';

class BookingStore {
  BookingService _bookingService = BookingService();

  String? errorMessage;

  bool isLoading = false;

  List<BookingModel> bookingList = [];

  Future<void> getBookingList() async {
    try {
      final result = await _bookingService.getBookingList();
      final bookings = (result as List<dynamic>?) ?? [];
      bookingList.clear();
      bookings.forEach((element) {
        bookingList.add(BookingModel.fromJson(element));
      });
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  Future<void> cancelBooking({
    required String id,
  }) async {
    try {
      await _bookingService.cancelBooking(
        id: id,
      );
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }
  }
}
