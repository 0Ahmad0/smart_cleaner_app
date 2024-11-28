import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:smart_cleaner_app/app/controllers/auth_controller.dart';
import 'package:smart_cleaner_app/core/helpers/extensions.dart';
import 'package:smart_cleaner_app/core/routing/routes.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/string_manager.dart';

import '../../../../../../core/models/weather_model.dart';
import '../../../controllers/weathers_controller.dart';
import '../../../utils/constants.dart';
import 'weather_screen_model.dart';


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late WeathersController controller;
  void initState() {
    controller = Get.put(WeathersController());
    controller.onInit();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherScreenModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.weatherStatisticsText),
        actions: [
          IconButton(onPressed: (){
            context.pushNamed(Routes.weatherChartRoute,arguments: {
              "weathers":controller.weathers.items
            });
          }, icon: Icon(Icons.bar_chart_outlined))
        ],
      ),
      backgroundColor: Colors.white,
      body:
      StreamBuilder<DatabaseEvent>(
          stream: controller.getWeathers,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.active) {
              if (snapshot.hasData) {

                controller.weathers.items.clear();
                if ((snapshot.data?.snapshot.children.length ?? 0) > 0) {
                  controller.weathers.items = Weathers
                      .fromJsonReal(snapshot.data!.snapshot.children).items;
                }
                controller.filterWeathers(
                    term: controller.searchController.value.text);
              }
            }
            return
              GetBuilder<WeathersController>(
                builder: (WeathersController weathersController) =>
                model.forecastObject?.location?.name != null &&
                    model.loading == false
                    ? _ViewWidget(weathersController.weather)
                    : Center(
                  child: SpinKitChasingDots(
                    color: ColorManager.primaryColor,
                    size: 80.sp,
                  ),
                ),

              );
          }
      )
    );
  }
}

class _ViewWidget extends StatelessWidget {
  _ViewWidget(this.weatherModel);
  final WeatherModel? weatherModel;
  @override
  Widget build(BuildContext context) {
    final model = context.read<WeatherScreenModel>();

    return SafeArea(
      child: Stack(
        children: [
          model.forecastObject!.location!.name != 'Null'
              ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:  [
                        SizedBox(height: 70),
                        CityInfoWidget(weatherModel: weatherModel,),
                        SizedBox(height: 15),
                        CarouselWidget(),
                        SizedBox(height: 15),
                        WindWidget(),
                        SizedBox(height: 15),
                        BarometerWidget(weatherModel: weatherModel,),
                      ]),
                )
              : Center(
                  child: appText(size: 16, text: 'Произошла ошибка'),
                ),
          const HeaderWidget(),
        ],
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<WeatherScreenModel>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: ((value) => model.cityName = value),
              onSubmitted: (_) => model.onSubmitSearch(),
              decoration: InputDecoration(
                filled: true,
                fillColor: bgGreyColor.withAlpha(235),
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.blue.withAlpha(135)),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.blue),
                  onPressed: model.onSubmitSearch,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: bgGreyColor.withAlpha(235),
            ),
            child: IconButton(
              padding: const EdgeInsets.all(12),
              iconSize: 26,
              onPressed: model.onSubmitLocate,
              icon: const Icon(Icons.location_on_outlined, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}

class CityInfoWidget extends StatelessWidget {
  const CityInfoWidget({Key? key, this.weatherModel}) : super(key: key);
  final WeatherModel? weatherModel;
  @override
  Widget build(BuildContext context) {
    final model = context.read<WeatherScreenModel>();
    // final WeatherModel? weatherModel=Get.put(WeathersController()).weather;
    final snapshot = model.forecastObject;
    var city = snapshot!.location?.name;
    var temp = weatherModel?.temperature?.round()??snapshot.current?.tempC!.round();
    var feelTemp = snapshot.current?.feelslikeC;
    var windDegree = snapshot.current?.windDegree;
    var url =
        'https://${((snapshot.current!.condition!.icon).toString().substring(2)).replaceAll("64", "128")}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(url, scale: 1.2),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: appText(
                size: 24.sp,
                text: '$city',
                isBold: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            RotationTransition(
              turns: AlwaysStoppedAnimation(windDegree! / 360),
              child: const Icon(Icons.north, color: primaryColor),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            appText(
              size: 70,
              text: '$temp°',
            ),
            appText(size: 20, text: '$feelTemp°', color: darkGreyColor),
          ],
        ),
      ],
    );
  }
}

class BarometerWidget extends StatelessWidget {
  const BarometerWidget({Key? key, this.weatherModel}) : super(key: key);
  final WeatherModel? weatherModel;
  @override
  Widget build(BuildContext context) {
    // final WeatherModel? weatherModel=Get.put(WeathersController()).weather;
    final model = context.read<WeatherScreenModel>();
    final snapshot = model.forecastObject;
    var temperature =weatherModel?.temperature?? snapshot!.current?.tempC;
    var humidity = weatherModel?.humidity??snapshot!.current?.humidity;
    var pressure = weatherModel?.pressure??snapshot!.current?.pressureMb;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: appText(
              size: 20,
              color: primaryColor.withOpacity(.8),
              text: 'Barometer',
              isBold: FontWeight.bold,
            ),
          ),
          Card(
            color: bgGreyColor,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customListTile(
                    first: 'Temperature:',
                    second: ' $temperature °C',
                    icon: Icons.thermostat,
                    iconColor: Colors.orange,
                  ),
                  customListTile(
                    first: 'Humidity:',
                    second: ' $humidity %',
                    icon: Icons.water_drop_outlined,
                    iconColor: Colors.blueGrey,
                  ),
                  customListTile(
                    first: 'Pressure:',
                    second: ' $pressure hPa',
                    icon: Icons.speed,
                    iconColor: Colors.red[300]!,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WindWidget extends StatelessWidget {
  const WindWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<WeatherScreenModel>();
    final snapshot = model.forecastObject;
    var speed = snapshot!.current?.windKph;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: appText(
              size: 20,
              color: primaryColor.withOpacity(.8),
              text: 'Wind',
              isBold: FontWeight.bold,
            ),
          ),
          Card(
            color: bgGreyColor,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customListTile(
                    text: snapshot.current!.windDir!,
                    first: 'Speed:',
                    second: ' $speed km/h',
                    icon: Icons.air,
                    iconColor: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<WeatherScreenModel>();
    final snapshot = model.forecastObject;
    return SizedBox(
      height: 100,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: 23,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, index) {
          return Container(
            margin: index == 0 ? const EdgeInsets.only(left: 20) : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  index < 11
                      ? appText(
                          size: 14,
                          text: '${index + 1} am',
                          color: primaryColor)
                      : index == 11
                          ? appText(
                              size: 14,
                              text: '${index + 1} pm',
                              color: primaryColor)
                          : appText(
                              size: 14,
                              text: '${index - 11} pm',
                              color: primaryColor),
                  const SizedBox(height: 10),
                  Image.network(
                      'https://${(snapshot!.forecast!.forecastday![0].hour![index].condition!.icon).toString().substring(2)}',
                      scale: 2),
                  const SizedBox(height: 5),
                  appText(
                    size: 14,
                    text:
                        '${snapshot.forecast!.forecastday![0].hour![index].tempC}°',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
