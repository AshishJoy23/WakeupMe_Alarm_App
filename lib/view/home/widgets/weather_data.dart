import 'package:alarm_app_test/controller/weather_controller.dart';
import 'package:alarm_app_test/model/weather_model.dart';
import 'package:alarm_app_test/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WeatherDataWidget extends StatefulWidget {
  const WeatherDataWidget({super.key});

  @override
  State<WeatherDataWidget> createState() => _WeatherDataWidgetState();
}

class _WeatherDataWidgetState extends State<WeatherDataWidget> {
  String city = "";
  String date = DateFormat("yMMMMd").format(DateTime.now());
  final WeatherController globalController = Get.put(WeatherController());
 

  @override
  void initState() {
    getAddress(globalController.getLatitude().value,
        globalController.getLongitude().value);
    super.initState();
  }

  Future getAddress(lat, long) async {
    List<Placemark> placemark = await placemarkFromCoordinates(lat, long);
    Placemark place = placemark[0];
    setState(() {
      city = place.locality!;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.topLeft,
          child: Text(
            city,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              height: 2,
              color: CustomColors.secondaryTextColor
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
          alignment: Alignment.topLeft,
          child: Text(
            date,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: CustomColors.secondaryTextColor.withAlpha(220),
              height: 1,
            ),
          ),
        ),
        Obx(
          ()=> Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
          Image.asset(
            "assets/weather/${globalController.weatherData.value.current!.weather![0].icon}.png",
            height: size.height*0.1,
            width: size.height*0.1,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: InkWell(
                  onTap: () {
                    globalController.getCurrentLocation();
                  },
                  child: Icon(
                        Icons.refresh,
                        color: Colors.black54,
                        size: 40,
                      ),
                ),
              );
            },
          ),
          Container(
            height: size.height*0.08,
            width: 1,
            color: Colors.black45,
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: "${globalController.weatherData.value.current!.temp!.toInt()}°",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 50,
                  color: CustomColors.secondaryTextColor,
                ),
              ),
              TextSpan(
                text: "${globalController.weatherData.value.current!.weather![0].description}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: CustomColors.secondaryTextColor.withAlpha(220),
                ),
              ),
            ]),
          ),
                ],
              ),
        )
      ],
    );
  }
}
