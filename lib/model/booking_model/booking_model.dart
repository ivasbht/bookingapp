class BookingModel {
  final id;
  final airline;
  final flight_number;
  final departure_airport;
  final departure_time;
  final arrival_airport;
  final arrival_time;
  final duration;
  final layovers;
  final price;
  final currency;
  final booking_url;

  BookingModel({
    this.id,
    this.airline,
    this.flight_number,
    this.departure_airport,
    this.departure_time,
    this.arrival_airport,
    this.arrival_time,
    this.duration,
    this.layovers,
    this.price,
    this.currency,
    this.booking_url,
  });

  factory BookingModel.fromJson(Map<String, dynamic> parseJson) {
    return BookingModel(
      id: parseJson['id'],
      airline: parseJson['airline'],
      flight_number: parseJson['flight_number'],
      departure_airport: parseJson['departure_airport'],
      departure_time: parseJson['departure_time'],
      arrival_airport: parseJson['arrival_airport'],
      arrival_time: parseJson['arrival_time'],
      duration: parseJson['duration'],
      layovers: parseJson['layovers'],
      price: parseJson['price'],
      currency: parseJson['currency'],
      booking_url: parseJson['booking_url'],
    );
  }

  toMap() {
    return {
      "id": id,
      "airline": airline,
      "flight_number": flight_number,
      "departure_airport": departure_airport,
      "departure_time": departure_time,
      "arrival_airport": arrival_airport,
      "arrival_time": arrival_time,
      "duration": duration,
      "layovers": layovers,
      "price": price,
      "currency": currency,
      "booking_url": booking_url,
    };
  }
}
