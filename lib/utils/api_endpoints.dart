
const apiKey = "b0d7ab293ce41944801c2f09fb30a155";
String apiURL(var lat, var long){
  String url;
  url = "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$long&appid=$apiKey&units=metric&exclude=minutely";
  return url;
}