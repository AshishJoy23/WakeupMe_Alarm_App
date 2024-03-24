import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:alarm_app_test/model/weather_model.dart';
import 'package:alarm_app_test/utils/api_endpoints.dart';

class FetchWeatherAPI {
  WeatherDataModel? weatherData;

  //processing the weather data from response -> to json
  Future<WeatherDataModel> processData(lat, long) async {
    var response = await http.get(Uri.parse(apiURL(lat, long)));
    var jsonString = jsonDecode(response.body);
    weatherData = WeatherDataModel.fromJson(jsonString);
    log(response.statusCode.toString());
    log(response.body.toString());
    return weatherData!;
  }
}
