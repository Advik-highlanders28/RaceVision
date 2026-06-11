import 'dart:convert';
import 'package:http/http.dart' as http;

class Openf1Service {
  Future<List<double>> fetchLapTimes(int driverNumber) async {
    final url = Uri.parse(
      'https://api.openf1.org/v1/laps?session_key=latest&driver_number=$driverNumber',
    );
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load data');
    }

    final data = jsonDecode(response.body);

    List<double> lapTimes = [];

    for (var lap in data) {
      if (lap['lap_duration'] != null) {
        lapTimes.add((lap['lap_duration'] as num).toDouble());
      }
    }

    return lapTimes;
  }
}
