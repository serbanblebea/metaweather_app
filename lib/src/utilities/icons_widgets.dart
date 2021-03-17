import 'package:flutter/material.dart';

class LocationIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.near_me,
      color: Colors.white,
      size: 50.0,
    );
  }
}

class LocationCityIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.location_city,
      color: Colors.white,
    );
  }
}
