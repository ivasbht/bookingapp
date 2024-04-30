import 'package:bookingapp/model/booking_model/booking_model.dart';
import 'package:bookingapp/service/booking_service/booking_service.dart';
import 'package:bookingapp/service/user_service/user_service.dart';

class HomeStore {
  BookingService _bookingService = BookingService();
  UserLocalService userService = UserLocalService();

  String? errorMessage;

  bool isLoading = false;

  List<BookingModel> flightsList = [];

  List<BookingModel> searchedFlightsList = [];

  List<BookingModel> bookingList = [];

  Future<void> getFlightList() async {
    try {
      final result = await _bookingService.getFlightList();
      final flights = (result as List<dynamic>?) ?? [];
      flightsList.clear();
      flights.forEach((element) {
        flightsList.add(BookingModel.fromJson(element));
      });
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }
  }

  void searchFlightList(String? query) async {
    if (query == null || query.isEmpty) {
      searchedFlightsList = flightsList.map((e) => e).toList();
      return null;
    }
    final lowerCaseQuery = query.toLowerCase();
    searchedFlightsList = flightsList
        .where((element) {
          if (element.airline
              .toString()
              .toLowerCase()
              .contains(lowerCaseQuery)) {
            return true;
          }
          if (element.arrival_airport
              .toString()
              .toLowerCase()
              .contains(lowerCaseQuery)) {
            return true;
          }
          if (element.departure_airport
              .toString()
              .toLowerCase()
              .contains(lowerCaseQuery)) {
            return true;
          }
          if (element.arrival_time
              .toString()
              .toLowerCase()
              .contains(lowerCaseQuery)) {
            return true;
          }
          if (element.departure_time
              .toString()
              .toLowerCase()
              .contains(lowerCaseQuery)) {
            return true;
          }
          return false;
        })
        .map((e) => e)
        .toList();
  }

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

  Future<void> saveBooking({
    required String id,
    required BookingModel booking,
  }) async {
    try {
      await _bookingService.saveBooking(
        id: id,
        data: booking.toMap(),
      );
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
