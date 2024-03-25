import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:alarm_app_test/services/services.dart';
import 'package:alarm_app_test/model/models.dart';

class WeatherController extends GetxController {
  //create variables
  final RxBool _isLoading = true.obs;
  final RxDouble _latitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;
  var isError = false.obs;

  final weatherData = WeatherDataModel().obs;

  //get variables  by creating instance
  RxBool checkLoading() => _isLoading;
  RxDouble getLatitude() => _latitude;
  RxDouble getLongitude() => _longitude;
  WeatherDataModel getWeatherData() {
    return weatherData.value;
  }

  @override
  void onInit() {
    if (_isLoading.isTrue) {
      getPermission();
    }
    super.onInit();
  }

  Future<void> getPermission() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isServiceEnabled) {
      // Location service is disabled, prompt the user to enable it
      await Geolocator.openLocationSettings();
      // Wait for the user to enable location services
      isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      // If the user didn't enable location services, throw an error
      if (!isServiceEnabled) {
        throw Exception('Location is not enabled');
      }
    }

    //status of permission
    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error('Location Permission is denied forever');
    } else if (locationPermission == LocationPermission.denied) {
      //request permission
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error('Location Permission is denied');
      }
    }
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
//update the current location by giving the latitude and longitude
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) async {
      //update our latitude and longitude
      _latitude.value = value.latitude;
      _longitude.value = value.longitude;
      // Check for internet connectivity
      bool isConnected = await isInternetConnected();
      if (isConnected) {
        // Fetch latest data if online
        //calling our weather api
        return FetchWeatherAPI()
            .processData(value.latitude, value.longitude)
            .then((value) {
          if (value == null) {
            isError.value = true;
            _isLoading.value = false;
            return Future.error('Something went wrong');
          }
          weatherData.value = value;
          _isLoading.value = false;
        });
      } else {
        weatherData.value = WeatherDataModel(
          current: CurrentData(
            temp: 0,
            weather: [
              WeatherData(description: 'You are offline', icon: ''),
            ],
          ),
        );
        _isLoading.value = false;
      }
    });
  }

  Future<bool> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // Internet connection available
      } else {
        return false; // No internet connection
      }
    } on SocketException catch (_) {
      return false; // No internet connection
    }
  }
}
