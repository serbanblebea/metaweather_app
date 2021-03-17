import 'package:weather_app/src/services/location.dart';
import 'package:weather_app/src/services/networking.dart';

const String metaWeatherURL = 'https://www.metaweather.com/api/location';

class WeatherModel {
  Future<Map<String, dynamic>> getWoeidWeather(num woeid) async {
    final NetworkHelper networkHelper = NetworkHelper('$metaWeatherURL/$woeid/');

    final Map<String, dynamic> weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<Map<String, dynamic>> getLocationWeather() async {
    final Location myLocation = Location();
    await myLocation.getCurrentLocation();

    final NetworkHelper networkHelper = NetworkHelper(
        '$metaWeatherURL/search/?lattlong=${myLocation.latitude.toStringAsFixed(2)},${myLocation.longitude.toStringAsFixed(2)}');

    final List<dynamic> locationData = await networkHelper.getData();
    final num woeid = locationData[0]['woeid'];
    final Map<String, dynamic> weatherData = await WeatherModel().getWoeidWeather(woeid);
    return weatherData;
  }

  Future<Map<String, dynamic>> getCityWeather(String cityName) async {
    final String url = '$metaWeatherURL/search/?query=$cityName';
    final NetworkHelper networkHelper = NetworkHelper(url);
    final List<dynamic> cityData = await networkHelper.getData();
    if (cityData.isEmpty) {
      return null;
    }
    final num woeid = cityData[0]['woeid'];
    final Map<String, dynamic> weatherData = await WeatherModel().getWoeidWeather(woeid);
    return weatherData;
  }

  static String getMessage(String cityName, String weatherState) {
    if (cityName == '') {
      return 'City not found.';
    }
    return weatherState + ' in ' + cityName;
  }
}
