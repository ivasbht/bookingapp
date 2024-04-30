import 'package:bookingapp/model/booking_model/booking_model.dart';
import 'package:bookingapp/store/booking_store/booking_store.dart';
import 'package:bookingapp/utility/loading_widget/loading_widget.dart';
import 'package:bookingapp/utility/mixin/base_mixin/base_mixin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MybookingScreen extends BasePageWidget {
  const MybookingScreen({Key? key}) : super(key: key);

  @override
  BaseState<MybookingScreen> createState() => _MybookingScreenState();
}

class _MybookingScreenState extends BaseState<MybookingScreen> {
  BookingStore _store = BookingStore();

  @override
  void initializeWithContext(BuildContext context) {
    super.initializeWithContext(context);
    _callList();
  }

  void _callList() {
    _getBookingDetails();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
      loading: _store.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Bookings"),
          actions: [
            IconButton(
              onPressed: () {
                _callList();
              },
              icon: Icon(Icons.refresh_outlined),
            ),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            ..._store.bookingList.map((flights) {
              return _buildListElement(
                flights: flights,
                isBooked: false,
                onPressCancel: () {
                  _store
                      .cancelBooking(
                    id: flights.id,
                  )
                      .then((value) {
                    _callList();
                  });
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildListElement({
    required BookingModel flights,
    void Function()? onPressBook,
    void Function()? onPressCancel,
    bool isBooked = true,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text.rich(
            TextSpan(
              text: flights.airline,
              children: [
                TextSpan(
                  text: " (${flights.flight_number})",
                ),
              ],
            ),
          ),
          subtitle: Text.rich(
            TextSpan(
              text: "${flights.departure_airport} - ${flights.arrival_airport}",
              children: [
                TextSpan(
                  text: "\nDeparture: ${dateFormat(flights.arrival_time)}",
                ),
                TextSpan(
                  text: "\nArrival: ${dateFormat(flights.arrival_time)}",
                ),
                TextSpan(
                  text: "\nduration: ${flights.duration}",
                ),
                TextSpan(
                  text: "\n\nAmount: ${flights.currency} ${flights.price}\n\n",
                ),
              ],
            ),
          ),
          trailing: TextButton(
            onPressed: isBooked ? onPressBook : onPressCancel,
            style: TextButton.styleFrom(
              backgroundColor: isBooked ? Colors.red : Colors.white,
            ),
            child: Text(
              isBooked ? "Book" : "Cancel",
              style: TextStyle(
                fontSize: 16,
                color: isBooked ? Colors.white : Colors.red,
              ),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Future<void> _getBookingDetails() async {
    _store.isLoading = true;
    await _store.getBookingList().then((value) {
      setState(() {
        _store.isLoading = false;
      });
      if (_store.errorMessage != null) {
        toastMessage("${_store.errorMessage}");
      }
    });
  }

  void toastMessage(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? "")),
    );
  }

  String dateFormat(String date) {
    return DateFormat.yMEd()
        .add_jm()
        .format(DateTime.tryParse(date) ?? DateTime.now());
  }
}
