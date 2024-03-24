//instance for getting api response
class WeatherDataModel {
  final CurrentData? current;
  WeatherDataModel({ this.current});

  factory WeatherDataModel.fromJson(Map<String, dynamic> json) =>
      WeatherDataModel(current: CurrentData.fromJson(json['current']));
}

class CurrentData {
  int? temp;
  List<WeatherData>? weather;

  CurrentData({
    this.temp,
    this.weather,
  });

  factory CurrentData.fromJson(Map<String, dynamic> json) => CurrentData(
        temp: (json['temp'] as num?)?.round(),
        weather: (json['weather'] as List<dynamic>?)
            ?.map((e) => WeatherData.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'temp': temp,
        'weather': weather?.map((e) => e.toJson()).toList(),
      };
}

class WeatherData {
  int? id;
  String? main;
  String? description;
  String? icon;

  WeatherData({
    this.id,
    this.main,
    this.description,
    this.icon,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
        id: json['id'] as int?,
        main: json['main'] as String?,
        description: json['description'] as String?,
        icon: json['icon'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'main': main,
        'description': description,
        'icon': icon,
      };
}
