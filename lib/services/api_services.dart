import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:alarm_app_test/model/weather_model.dart';
import 'package:alarm_app_test/utils/api_endpoints.dart';

class FetchWeatherAPI {
  WeatherDataModel? weatherData;

  //processing the weather data from response -> to json
  Future<WeatherDataModel?> processData(lat, long) async {
    try {
      var response = await http.get(Uri.parse(apiURL(lat, long)));
      if (response.statusCode==200) {
        var jsonString = jsonDecode(response.body);
        log(response.body.toString());
      weatherData = WeatherDataModel.fromJson(jsonString);
      return weatherData!;
      } else {
        log('Erorr: ${response.statusCode}');
        return null;
      }
      
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }
}
