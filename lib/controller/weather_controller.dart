import 'package:alarm_app_test/model/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../services/api_services.dart';

class WeatherController extends GetxController {
  //create variables
  final RxBool _isLoading = true.obs;
  final RxDouble _latitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;
  final RxInt _currentIndex = 0.obs;

  final weatherData = WeatherDataModel().obs;

  //get variables  by creating instance
  RxBool checkLoading() => _isLoading;
  RxDouble getLatitude() => _latitude;
  RxDouble getLongitude() => _longitude;
  WeatherDataModel getWeatherData(){
    return weatherData.value;
  }

  @override
  void onInit() {
    if (_isLoading.isTrue) {
      getLocation();
    } else{
      getIndex();
    }
    super.onInit();
  }

  getLocation() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    //return if service is not enabled
    if (!isServiceEnabled) {
      return Future.error('Location is not enabled');
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

    //update the current location by giving the latitude and longitude
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      //update our latitude and longitude
      _latitude.value = value.latitude;
      _longitude.value = value.longitude;
      //calling our weather api
      return FetchWeatherAPI().processData(value.latitude, value.longitude).then((value) {
        weatherData.value = value;
         _isLoading.value = false;
      }
     );
    });
  }
  
  RxInt getIndex() {
    return _currentIndex;
  }
}
