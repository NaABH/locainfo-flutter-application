import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/utilities/weather/weather.dart';

class MyWeatherWidget extends StatelessWidget {
  final Weather weatherInformation;
  const MyWeatherWidget({super.key, required this.weatherInformation});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (weatherInformation.iconUrl != null)
          Image.network(
            weatherInformation.iconUrl!,
            width: 30,
            height: 30,
          )
        else
          Container(),
        Text(
          weatherInformation.condition != null
              ? '${weatherInformation.condition!}, ${weatherInformation.temperature}°C'
              : 'Unknown, ? °C',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}
