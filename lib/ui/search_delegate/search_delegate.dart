import 'package:bookingapp/model/booking_model/booking_model.dart';
import 'package:bookingapp/store/home_store/home_store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FlightSearchDelegate extends SearchDelegate<String> {
  HomeStore _store = HomeStore();
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildBody();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _callList();
    return _buildBody();
  }

  Future<void> _getFlightDetails() async {
    await _store.getFlightList();
  }

  Future<void> _getSearchDetails() async {
    _store.searchFlightList(query);
  }

  Future<void> _getBookingDetails() async {
    await _store.getBookingList();
  }

  void _callSearchedList() {
    _getSearchDetails().then((value) {
      _getBookingDetails();
    });
  }

  void _callList() async {
    await _getFlightDetails();
    _callSearchedList();
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            ..._store.searchedFlightsList.map((flights) {
              return StatefulBuilder(builder: (context, setBook) {
                return _buildListElement(
                  flights: flights,
                  isBooked: !_store.bookingList
                      .any((booked) => booked.id == flights.id),
                  onPressBook: () {
                    _store
                        .saveBooking(
                      id: flights.id,
                      booking: flights,
                    )
                        .then((value) {
                      _callList();
                      setBook(() {});
                    });
                  },
                  onPressCancel: () {
                    _store
                        .cancelBooking(
                      id: flights.id,
                    )
                        .then((value) {
                      _callList();
                      setBook(() {});
                    });
                  },
                );
              });
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

  String dateFormat(String date) {
    return DateFormat.yMEd()
        .add_jm()
        .format(DateTime.tryParse(date) ?? DateTime.now());
  }
}
