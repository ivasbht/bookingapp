import 'package:bookingapp/const/routes/routes.dart';
import 'package:bookingapp/model/booking_model/booking_model.dart';
import 'package:bookingapp/store/home_store/home_store.dart';
import 'package:bookingapp/ui/search_delegate/search_delegate.dart';
import 'package:bookingapp/utility/loading_widget/loading_widget.dart';
import 'package:bookingapp/utility/mixin/base_mixin/base_mixin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends BasePageWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen> {
  HomeStore _store = HomeStore();

  @override
  void initializeWithContext(BuildContext context) {
    super.initializeWithContext(context);
    _store.isLoading = true;
    Future.delayed(Duration(seconds: 2), () {
      _callList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
      loading: _store.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Flights Available"),
          actions: [
            IconButton(
              onPressed: () async {
                await showSearch(
                  context: context,
                  delegate: FlightSearchDelegate(),
                ).then((value) {
                  _callList();
                });
              },
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                _store.userService.deleteUserLocal().then((value) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.intro_screen,
                    (route) => false,
                  );
                });
              },
              icon: Icon(Icons.logout_sharp),
            ),
            IconButton(
              onPressed: () {
                _getFlightDetails().then((value) {
                  _getBookingDetails();
                });
              },
              icon: Icon(Icons.refresh_outlined),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.mybooking_screen).then((value) {
              _callList();
            });
          },
          child: Icon(
            Icons.list,
          ),
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
            ..._store.flightsList.map((flights) {
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
                  });
                },
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

  Future<void> _getFlightDetails() async {
    setState(() {
      _store.isLoading = true;
    });
    await _store.getFlightList().then((value) {
      setState(() {
        _store.isLoading = false;
      });
      if (_store.errorMessage != null) {
        toastMessage("${_store.errorMessage}");
      }
    });
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

  void _callList() {
    _getFlightDetails().then((value) {
      _getBookingDetails();
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
