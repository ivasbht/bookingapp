import 'package:bookingapp/const/config/config.dart';
import 'package:hive/hive.dart';

class BookingDBStore {
  late Box _booking;
  BookingDBStore() {
    _openCollection();
  }

  void _openCollection() async {
    if (Hive.isBoxOpen(Config.bookingCollection)) {
      _booking = Hive.box(Config.bookingCollection);
    } else {
      _booking = await Hive.openBox(Config.bookingCollection);
    }
  }

  Future<void> saveBooking({
    required String id,
    required Map<String, dynamic> savedValue,
  }) async {
    if (savedValue.isNotEmpty) {
      await _booking.put(id, savedValue);
    }
  }

  dynamic getBookingList() {
    return _booking.values.toList();
  }

  Future<void> deleteAllBooking() async {
    await _booking.clear();
  }

  Future<void> deleteBookingWithId({required String id}) async {
    await _booking.delete(id);
  }

  void closeCollection() async {
    Hive.close();
  }
}
