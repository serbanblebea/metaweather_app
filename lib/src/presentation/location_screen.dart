import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/src/utilities/constants.dart';
import 'package:weather_app/src/services/weather.dart';
import 'package:weather_app/src/utilities/icons_widgets.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({this.locationWeather});

  final Map<String, dynamic> locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  int temperature;
  String cityName;
  String weatherState;
  String metricSystem = 'C';
  List<bool> isSelected = [true, false];
  final fieldText = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(Map<String, dynamic> weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        cityName = '';
        weatherState = '';
        return;
      }
      temperature = weatherData['consolidated_weather'][0]['the_temp'].toInt();
      cityName = weatherData['title'];
      weatherState = weatherData['consolidated_weather'][0]['weather_state_name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      final Map<String, dynamic> weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: LocationIcon(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: ToggleButtons(
                      children: <Widget>[
                        Text(
                          '°C',
                          style: kButtonTextStyle,
                        ),
                        Text(
                          '°F',
                          style: kButtonTextStyle,
                        ),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          if (index == 0) {
                            metricSystem = 'C';
                            isSelected[0] = true;
                            isSelected[1] = false;
                          } else {
                            metricSystem = 'F';
                            isSelected[0] = false;
                            isSelected[1] = true;
                          }
                        });
                      },
                      isSelected: isSelected,
                    ),
                  ),
                ],
              ),
              Container(
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        child: TextField(
                          controller: fieldText,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter city name',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (String value) {
                            cityName = value;
                          },
                          onSubmitted: (String cityName) async {
                            final Map<String, dynamic> weatherData = await weather.getCityWeather(cityName);
                            fieldText.clear();
                            updateUI(weatherData);
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LocationCityIcon(),
                          TextButton(
                            onPressed: () async {
                              if (cityName != null) {
                                final Map<String, dynamic> weatherData = await weather.getCityWeather(cityName);
                                updateUI(weatherData);
                              }
                            },
                            child: const Text(
                              'Get Weather',
                              style: kButtonTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 32.0),
                child: Row(
                  children: <Widget>[
                    metricSystem == 'C'
                        ? Text(
                            '$temperature°$metricSystem',
                            style: kTempTextStyle,
                          )
                        : Text(
                            '${(temperature * 1.8 + 32).toInt()}°$metricSystem',
                            style: kTempTextStyle,
                          ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text(
                    WeatherModel.getMessage(cityName, weatherState),
                    textAlign: TextAlign.left,
                    style: kMessageTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
