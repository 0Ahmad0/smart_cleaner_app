
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // لتنسيق التاريخ

import '../../core/models/weather_model.dart';
import '../../core/utils/color_manager.dart';
import '../../core/utils/style_manager.dart';
import '../../core/widgets/app_padding.dart';

class WeatherChartScreen extends StatefulWidget {
  @override
  _WeatherChartScreenState createState() => _WeatherChartScreenState();
}

class _WeatherChartScreenState extends State<WeatherChartScreen> {
  List<WeatherModel>? weathers;
  bool isWeekly = true;

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map?;
    weathers ??= args?['weathers'] ?? [];

    // تصفية البيانات بناءً على الحالة الأسبوعية أو الشهرية
    final filteredData = isWeekly
        ? groupByWeeks(weathers ?? [])
        : groupByMonths(weathers ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Chart'),
        centerTitle: true,
      ),
      body: AppPaddingWidget(
        child: Column(
          children: [
            // زر التبديل بين الأسبوعي والشهري
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => setState(() => isWeekly = true),
                  child: Text(
                    'Weekly',
                    style: StyleManager.font14Bold(
                      color: isWeekly ? ColorManager.primaryColor : ColorManager.hintTextColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => isWeekly = false),
                  child: Text(
                    'Monthly',
                    style: StyleManager.font14Bold(
                      color: !isWeekly ? ColorManager.primaryColor : ColorManager.hintTextColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // المخطط
            Expanded(
              child: LineChart(
                buildChartData(filteredData),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 10,
                  width: 10,
                  color: Colors.red,
                ),
                SizedBox(width: 5),
                Text('Temperature', style: TextStyle(color: Colors.black)),
                SizedBox(width: 20),
                Container(
                  height: 10,
                  width: 10,
                  color: Colors.blue,
                ),
                SizedBox(width: 5),
                Text('Pressure', style: TextStyle(color: Colors.black)),
                SizedBox(width: 20),
                Container(
                  height: 10,
                  width: 10,
                  color: Colors.green,
                ),
                SizedBox(width: 5),
                Text('Humidity', style: TextStyle(color: Colors.black)),
              ],
            ),

        ],
        ),
      ),
    );
  }

  // إنشاء بيانات المخطط
  LineChartData buildChartData(Map<String, List<WeatherModel>> data) {
    List<FlSpot> temperatureSpots = [];
    List<FlSpot> pressureSpots = [];
    List<FlSpot> humiditySpots = [];
    if(data.length<2){
      Map<String, List<WeatherModel>>test={
        "init":[WeatherModel(pressure: 0,temperature: 0,humidity: 0)]
      };
      test.addAll(data);
      data=test;
    }
    int index = 0;
    data.forEach((key, value) {
      final avgTemperature = value.map((e) => e.temperature ?? 0).reduce((a, b) => a + b) / value.length;
      final avgPressure = value.map((e) => e.pressure ?? 0).reduce((a, b) => a + b) / value.length;
      final avgHumidity = value.map((e) => e.humidity ?? 0).reduce((a, b) => a + b) / value.length;

      // تطبيع القيم بتقسيمها على عوامل التقسيم
      final normalizedTemperature = avgTemperature / 1;
      final normalizedPressure = avgPressure / 1000;
      final normalizedHumidity = avgHumidity / 1;

      // إضافة النقاط
      temperatureSpots.add(FlSpot(index.toDouble(), double.parse(normalizedTemperature.toStringAsFixed(2))));
      pressureSpots.add(FlSpot(index.toDouble(), double.parse(normalizedPressure.toStringAsFixed(2))));
      humiditySpots.add(FlSpot(index.toDouble(), double.parse(normalizedHumidity.toStringAsFixed(2))));


      // temperatureSpots.add(FlSpot(index.toDouble(),double.parse(avgTemperature.toStringAsFixed(2)) ));
      // pressureSpots.add(FlSpot(index.toDouble(),double.parse(avgPressure.toStringAsFixed(2)) ));
      // humiditySpots.add(FlSpot(index.toDouble(),double.parse(avgHumidity.toStringAsFixed(2)) ));


      // temperatureSpots.add(FlSpot(index.toDouble(), avgTemperature));
      // pressureSpots.add(FlSpot(index.toDouble(), avgPressure));
      // humiditySpots.add(FlSpot(index.toDouble(), avgHumidity));

      index++;
    });


    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < data.keys.length) {
                return Text(
                  data.keys.elementAt(index),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),

      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: temperatureSpots,
          isCurved: true,
          color: Colors.red,
          // colors: [Colors.red],
          barWidth: 3,
        ),
        LineChartBarData(
          spots: pressureSpots,
          isCurved: true,
          color: Colors.blue,
          // colors: [Colors.blue],
          barWidth: 3,
        ),
        LineChartBarData(
          spots: humiditySpots,
          isCurved: true,
          color: Colors.green,
          // colors: [Colors.green],
          barWidth: 3,
        ),
      ],
    );
  }
  LineChartData buildChartDataOld(Map<String, List<WeatherModel>> data) {
    List<FlSpot> temperatureSpots = [];
    List<FlSpot> pressureSpots = [];
    List<FlSpot> humiditySpots = [];

    int index = 0;
    data.forEach((key, value) {
      print(key);
      final avgTemperature = value.map((e) => e.temperature ?? 0).reduce((a, b) => a + b) / value.length;
      final avgPressure = value.map((e) => e.pressure ?? 0).reduce((a, b) => a + b) / value.length;
      final avgHumidity = value.map((e) => e.humidity ?? 0).reduce((a, b) => a + b) / value.length;

      temperatureSpots.add(FlSpot(index.toDouble(), avgTemperature));
      pressureSpots.add(FlSpot(index.toDouble(), avgPressure));
      humiditySpots.add(FlSpot(index.toDouble(), avgHumidity));
      index++;
    });
    print(data);
    print(pressureSpots);
    print(humiditySpots);
    print(temperatureSpots);

    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < data.keys.length) {
                return Text(
                  data.keys.elementAt(index),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),

      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: temperatureSpots,
          isCurved: true,
          color: Colors.red,
          // colors: [Colors.red],
          barWidth: 3,
        ),
        LineChartBarData(
          spots: pressureSpots,
          isCurved: true,
          color: Colors.blue,
          // colors: [Colors.blue],
          barWidth: 3,
        ),
        LineChartBarData(
          spots: humiditySpots,
          isCurved: true,
          color: Colors.green,
          // colors: [Colors.green],
          barWidth: 3,
        ),
      ],
    );
  }
  LineChartData buildChartDataOld2(Map<String, List<WeatherModel>> data) {
    List<FlSpot> temperatureSpots = [];
    List<FlSpot> pressureSpots = [];
    List<FlSpot> humiditySpots = [];

    // ابدأ بمؤشر الخطوط
    int index = 0;

    data.forEach((key, value) {
      // إضافة النقاط لكل قيمة
      for (int i = 0; i < value.length; i++) {
        temperatureSpots.add(FlSpot(index + i.toDouble(), value[i].temperature?.toDouble() ?? 0));
        pressureSpots.add(FlSpot(index + i.toDouble(), value[i].pressure?.toDouble() ?? 0));
        humiditySpots.add(FlSpot(index + i.toDouble(), value[i].humidity?.toDouble() ?? 0));
      }

      // زيادة الفاصل بين الخطوط
      index += value.length;
    });
    print(temperatureSpots);
    print(pressureSpots);

    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < data.keys.length) {
                return Text(
                  data.keys.elementAt(index),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: temperatureSpots,
          isCurved: true,
          color: Colors.red,
          barWidth: 3,
          dotData: FlDotData(show: false),
        ),
        LineChartBarData(
          spots: pressureSpots,
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
          dotData: FlDotData(show: false),
        ),
        LineChartBarData(
          spots: humiditySpots,
          isCurved: true,
          color: Colors.green,
          barWidth: 3,
          dotData: FlDotData(show: false),
        ),
      ],
    );
  }
  LineChartData buildChartDataOld3(Map<String, List<WeatherModel>> data) {
    List<FlSpot> temperatureSpots = [];
    List<FlSpot> pressureSpots = [];
    List<FlSpot> humiditySpots = [];

    data.forEach((key, value) {
      for (var weather in value) {
        final xValue = weather.timestamp!.millisecondsSinceEpoch.toDouble(); // تحويل الطابع الزمني إلى قيمة X
        temperatureSpots.add(FlSpot(xValue, weather.temperature?.toDouble() ?? 0));
        pressureSpots.add(FlSpot(xValue, weather.pressure?.toDouble() ?? 0));
        humiditySpots.add(FlSpot(xValue, weather.humidity?.toDouble() ?? 0));

      }
    });

    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
              return Text(
                DateFormat('dd/MM').format(date), // عرض التاريخ بصيغة يوم/شهر
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: temperatureSpots,
          isCurved: true,
          color: Colors.red,
          barWidth: 3,
          dotData: FlDotData(show: false),
        ),
        LineChartBarData(
          spots: pressureSpots,
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
          dotData: FlDotData(show: false),
        ),
        LineChartBarData(
          spots: humiditySpots,
          isCurved: true,
          color: Colors.green,
          barWidth: 3,
          dotData: FlDotData(show: false),
        ),
      ],
      minX: temperatureSpots.isNotEmpty ? temperatureSpots.first.x : 0,
      maxX: temperatureSpots.isNotEmpty ? temperatureSpots.last.x : 0,
    );
  }

  // تجميع البيانات حسب الأسابيع
  Map<String, List<WeatherModel>> groupByWeeks(List<WeatherModel> data) {
    final Map<String, List<WeatherModel>> grouped = {};

    for (var weather in data) {
      final week = DateFormat("'Week' w").format(weather.timestamp!);
      grouped.putIfAbsent(week, () => []).add(weather);
    }
    return grouped;
  }

  // تجميع البيانات حسب الأشهر
  Map<String, List<WeatherModel>> groupByMonths(List<WeatherModel> data) {
    final Map<String, List<WeatherModel>> grouped = {};
    for (var weather in data) {
      final month = DateFormat("MMM yyyy").format(weather.timestamp!);
      grouped.putIfAbsent(month, () => []).add(weather);
    }
    return grouped;
  }
}


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../core/models/weather_model.dart';
// import '../../core/utils/color_manager.dart';
// import '../../core/utils/style_manager.dart';
// import '../../core/widgets/app_padding.dart';
//
// class WeatherChartScreen extends StatefulWidget {
//   @override
//   _WeatherChartScreenState createState() => _WeatherChartScreenState();
// }
//
// class _WeatherChartScreenState extends State<WeatherChartScreen> {
//   List<WeatherModel>? weathers;
//   bool isWeekly = true;
//   @override
//   Widget build(BuildContext context) {
//
//     final args = (ModalRoute.of(context)?.settings.arguments ??
//         <String, dynamic>{}) as Map?;
//
//     weathers??=args?['weathers']??[];
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Weather Chart'),
//         centerTitle: true,
//       ),
//       body: AppPaddingWidget(
//       child: Column(
//       children: [
//       // زر التبديل بين الأسبوعي والشهري
//       Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         TextButton(
//           onPressed: () => setState(() => isWeekly = true),
//           child: Text(
//             'Weekly',
//             style: StyleManager.font14Bold(
//               color: isWeekly ? ColorManager.primaryColor : ColorManager.hintTextColor,
//
//             ),
//           ),
//         ),
//         TextButton(
//           onPressed: () => setState(() => isWeekly = false),
//           child: Text(
//             'Monthly',
//             style: StyleManager.font14Bold(
//               color: !isWeekly ? ColorManager.primaryColor : ColorManager.hintTextColor,
//             ),
//           ),
//         ),
//       ],
//     ),
//     SizedBox(height: 20),
//     // المخطط
//     Expanded(child: null,)
//     ])));
//   }
// }