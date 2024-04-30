import 'dart:convert';

import 'package:bookingapp/const/db_store/booking_db_store/booking_db_store.dart';
import 'package:flutter/services.dart';

class BookingService {
  BookingDBStore _dbStore = BookingDBStore();

  Future<dynamic> getFlightList() async {
    final response = await rootBundle.loadString('assets/flights.json');
    final data = await json.decode(response);
    return data['flights'];
  }

  Future<void> saveBooking({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    _dbStore.saveBooking(id: id, savedValue: data);
  }

  Future<dynamic> getBookingList() async {
    final response = await _dbStore.getBookingList();
    return response;
  }

  Future<void> cancelBooking({required String id}) async {
    await _dbStore.deleteBookingWithId(id: id);
  }
}
