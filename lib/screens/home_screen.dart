import 'dart:ui';

import 'package:cuaca/bloc/weather_bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              Align(
                alignment: const AlignmentDirectional(3, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.lightBlue),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(-3, -0.3),
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.lightBlue),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, -1.2),
                child: Container(
                  height: 300,
                  width: 600,
                  decoration: const BoxDecoration(
                      // shape: BoxShape.circle,
                      color: Colors.blueAccent),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                ),
              ),
              BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
                builder: (context, state) {
                  if (state is WeatherBlocSuccess) {
                    return SizedBox(
                      width: size.width,
                      height: size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good ${_setDayPeriod(DateTime.now().hour)}!',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat('EEEE, MMM dd')
                                .format(state.weather.date!),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w300),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Center(
                              child: Image.asset(
                                _setWeatherIcon(
                                    state.weather.weatherConditionCode!),
                                width: size.width / 2,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              '${state.weather.temperature?.celsius?.round()}ºC',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 55,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Center(
                            child: Text(
                              state.weather.weatherMain ?? '',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                state.weather.areaName ?? '',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _todayInfoWidget(
                                  'lib/assets/sunny.png',
                                  'Sunrise',
                                  DateFormat(DateFormat.HOUR_MINUTE)
                                      .format(state.weather.sunrise!)),
                              _todayInfoWidget(
                                  'lib/assets/sunset.png',
                                  'Sunset',
                                  DateFormat(DateFormat.HOUR_MINUTE)
                                      .format(state.weather.sunset!))
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Divider(
                              color: Colors.blueGrey,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _todayInfoWidget('lib/assets/hot_temp.png', 'Max',
                                  '${state.weather.tempMax?.celsius?.round()}ºC'),
                              _todayInfoWidget(
                                  'lib/assets/warm_temp.png',
                                  'Min',
                                  '${state.weather.tempMin?.celsius?.round()}ºC'),
                              _todayInfoWidget('lib/assets/humidity.png',
                                  "Humidity", '${state.weather.humidity} %')
                            ],
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _todayInfoWidget(String asset, String name, String value) {
    return Row(
      children: [
        Image.asset(
          asset,
          scale: 12,
        ),
        const SizedBox(
          width: 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w300),
            ),
            Text(
              value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700),
            )
          ],
        )
      ],
    );
  }

  String _setWeatherIcon(int code) {
    switch (code) {
      case >= 200 && < 300:
        return 'lib/assets/storm.png';
      case >= 300 && < 400:
        return 'lib/assets/drizzle.png';
      case >= 500 && < 600:
        return 'lib/assets/rainy.png';
      case >= 600 && < 700:
        return 'lib/assets/snowy.png';
      case >= 700 && < 800:
        return 'lib/assets/windy.png';
      case > 800 && < 900:
        return 'lib/assets/cloudy.png';
      default:
        return 'lib/assets/sunny.png';
    }
    /* 
    Make weather image dynamic like:
    - have sun vs moon by day,
    - have cloud in front if cloudy
    - set weather in from of the cloud */
  }

  String _setDayPeriod(int hour) {
    switch (hour) {
      case >= 4 && < 12:
        return 'Morning';
      case >= 12 && < 17:
        return 'Afternoon';
      case >= 17 && < 24:
        return 'Evening';
      default:
        return 'Night';
    }
  }
}
