import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';

import '../../core/models/weather_model.dart';

class WeatherChartScreen extends StatefulWidget {
  @override
  _WeatherChartScreenState createState() => _WeatherChartScreenState();
}

class _WeatherChartScreenState extends State<WeatherChartScreen> {
  bool isWeekly = true;
  List<WeatherModel>? weathers;
  List weeklyData = [15, 18, 20, 22, 19];
  List monthlyData = [15, 16, 18, 20, 19, 17, 16];

  Map<String, double> weeklyMap = {};
  Map<String, double> monthlyMap = {};

  List humidityWeeklyData = [];
  List humidityMonthlyData = [];

  Map<String, double> humidityWeeklyMap = {};
  Map<String, double> humidityMonthlyMap = {};

  Map<String, List<WeatherModel>> groupByWeek(List<WeatherModel> weathers) {
    Map<String, List<WeatherModel>> groupedData = {};
    DateFormat monthFormatter = DateFormat('MMM');
    DateTime? firstDate = weathers.isNotEmpty ? weathers.first.timestamp : null;

    if (firstDate != null) {
      weathers.forEach((weather) {
        if (weather.timestamp != null) {

          int daysDiff = weather.timestamp!.difference(firstDate).inDays;
          int weekNumber = (daysDiff ~/ 7) + 1;
          String monthKey = monthFormatter.format(weather.timestamp!); //
          String weekKey = "W$weekNumber-$monthKey";


          groupedData.putIfAbsent(weekKey, () => []);
          groupedData[weekKey]!.add(weather);
        }
      });
    }
    return groupedData;
  }
  Map<String, List<WeatherModel>> groupByMonth(List<WeatherModel> weathers) {
    Map<String, List<WeatherModel>> groupedData = {};
    DateFormat monthFormatter = DateFormat.MMMM();
    DateFormat formatter = DateFormat('MMM-yy');
    weathers.forEach((weather) {
      if (weather.timestamp != null) {

        // String monthKey = "${weather.timestamp!.year}-${weather.timestamp!.month.toString().padLeft(2, '0')}";
        // String monthKey = monthFormatter.format(weather.timestamp!);
        String monthKey = formatter.format(weather.timestamp!);


        groupedData.putIfAbsent(monthKey, () => []);
        groupedData[monthKey]!.add(weather);
      }
    });
    

    return groupedData;
  }
  List<double> calculateAverages(Map<String, List<WeatherModel>> dataMap, num? Function(WeatherModel) valueSelector) {
    return dataMap.values.map((dataList) {

      double sum = dataList.fold(0.0, (total, item) => total + (valueSelector(item) ?? 0));

      return dataList.isNotEmpty ? sum / dataList.length : 0.0;
    }).toList();
  }

  Map<String, double> calculateAverageMap(
      Map<String, List<WeatherModel>> dataMap, num? Function(WeatherModel) valueSelector) {
    return dataMap.map((key, dataList) {

      double sum = dataList.fold(0.0, (total, item) => total + (valueSelector(item) ?? 0));

      double average = dataList.isNotEmpty ? sum / dataList.length : 0.0;
      return MapEntry(key, average);
    });
  }
  List<int> generateBoundaries(Map<String, double> data) {
    List<int> boundaries = []; // البداية بالقيمة 0

    // جمع القيم في قائمة مرتبة
    List<double> values = data.values.toList()..sort();

    // البحث عن مضاعفات 3 حول القيم
    for (double value in values) {
      // أقرب مضاعف 3 أقل من القيمة
      int lowerBound = (value ~/ 3) * 3;
      if (!boundaries.contains(lowerBound)) boundaries.add(lowerBound);

      // أقرب مضاعف 3 أكبر من القيمة
      int upperBound = lowerBound + 3;
      if (!boundaries.contains(upperBound)) boundaries.add(upperBound);
    }

    // التحقق من الفجوات بين القيم
    for (int i = 1; i < values.length; i++) {
      int start = ((values[i - 1] ~/ 3) * 3).toInt();
      int end = ((values[i] ~/ 3) * 3).toInt();
      for (int j = start; j <= end; j += 3) {
        if (!boundaries.contains(j)) boundaries.add(j);
      }
    }

    boundaries.sort();
    return boundaries;
  }


  void calHumidity(){
    humidityWeeklyMap=calculateAverageMap(groupByWeek(weathers!), (weather) => weather.humidity) ;
    humidityMonthlyMap=calculateAverageMap(groupByMonth(weathers!), (weather) => weather.humidity) ;


  if(humidityWeeklyMap.length<2){
  Map<String, double> test={
  "init":0
  };
  test.addAll(humidityWeeklyMap);
  humidityWeeklyMap=test;
  }
  if(humidityMonthlyMap.length<2){
  Map<String, double> test={
  "init":0
  };
  test.addAll(humidityMonthlyMap);
  humidityMonthlyMap=test;
  }

    humidityWeeklyData =
        humidityWeeklyMap.values.toList()??
  generateBoundaries(humidityWeeklyMap);

    humidityMonthlyData=
        humidityMonthlyMap.values.toList()??
            generateBoundaries(humidityMonthlyMap);
}
  @override
  Widget build(BuildContext context) {

    final args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map?;

    weathers??=args?['weathers']??[];
    weeklyMap=calculateAverageMap(groupByWeek(weathers!), (weather) => weather.temperature) ;
    monthlyMap=calculateAverageMap(groupByMonth(weathers!), (weather) => weather.temperature) ;


    if(weeklyMap.length<2){
      Map<String, double> test={
        "init":0
      };
      test.addAll(weeklyMap);
      weeklyMap=test;
    }
    if(monthlyMap.length<2){
      Map<String, double> test={
        "init":0
      };
      test.addAll(monthlyMap);
      monthlyMap=test;
    }
    // weeklyMap={
    //   "week1": 23.3,
    //   "week2": 23.5,
    //   "week3": 27.0
    // };
    // print(weeklyMap);
    // print(monthlyMap);
     weeklyData =
         weeklyMap.values.toList()??
         generateBoundaries(weeklyMap);

    monthlyData=
        monthlyMap.values.toList()??
        generateBoundaries(monthlyMap);
    // print(weeklyData);
    // print(monthlyData);
    final dataMap = isWeekly ? weeklyMap : monthlyMap;

    final data = isWeekly ? weeklyData : monthlyData;


    calHumidity();

    final humidityDataMap = isWeekly ?  humidityWeeklyMap :  humidityMonthlyMap;

    final  humidityData = isWeekly ?  humidityWeeklyData :  humidityMonthlyData;
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
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        data.length,
                            (index) {
                          // if (index < dataMap.length) { // تحقق من صحة الفهرس
                            double value = data[index].toDouble();
                            // String key = dataMap.keys.elementAt(index); // الحصول على المفتاح (week1, week2, ...)
                           // print(value);
                            return FlSpot(index.toDouble(), value);
                          // }
                          return FlSpot(0, 0); // قيمة افتراضية إذا كان الفهرس غير صالح
                        },
                      ),
                      isCurved: true,
                      color: ColorManager.primaryColor,
                      barWidth: 2,
                      belowBarData: BarAreaData(
                        show: true,
                        color: ColorManager.primaryColor.withOpacity(0.3),
                      ),
                      dotData: FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: List.generate(
                        humidityData.length,
                            (index) {
                          // if (index < dataMap.length) { // تحقق من صحة الفهرس
                            double value = data[index].toDouble();
                            // String key = dataMap.keys.elementAt(index); // الحصول على المفتاح (week1, week2, ...)
                           // print(value);
                            return FlSpot(index.toDouble(), value);
                          // }
                          return FlSpot(0, 0); // قيمة افتراضية إذا كان الفهرس غير صالح
                        },
                      ),
                      isCurved: true,
                      color: ColorManager.successColor,
                      barWidth: 2,
                      // belowBarData: BarAreaData(
                      //   show: true,
                      //   color: ColorManager.successColor.withOpacity(0.3),
                      // ),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index =  value!=value.toInt()?-1:value.toInt();
                          // index-=1;
                          // print(value);
                          if (index >= 0 && index < data.length && index < dataMap.length) {
                            String key = dataMap.keys.elementAt(index); // الحصول على مفتاح الأسبوع
                            return Text(
                              key, // عرض "week1", "week2", ...
                              style: StyleManager.font10Medium(),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(
                    border: Border.all(color: ColorManager.grayColor),
                  ),
                ),
              ),
            )

            ,
          ],
        ),
      ),
    );
  }
}
// Map<String, List<WeatherModel>> groupByWeek(List<WeatherModel> weathers) {
//     Map<String, List<WeatherModel>> groupedData = {};
//     DateFormat monthFormatter = DateFormat('MMM');
//     DateTime? firstDate = weathers.isNotEmpty ? weathers.first.timestamp : null;
//
//     if (firstDate != null) {
//       weathers.forEach((weather) {
//         if (weather.timestamp != null) {
//
//           int daysDiff = weather.timestamp!.difference(firstDate).inDays;
//           int weekNumber = (daysDiff ~/ 7) + 1;
//           String monthKey = monthFormatter.format(weather.timestamp!); //
//           String weekKey = "W$weekNumber-$monthKey";
//
//
//           groupedData.putIfAbsent(weekKey, () => []);
//           groupedData[weekKey]!.add(weather);
//         }
//       });
//     }
//     return groupedData;
//   }
//   Map<String, List<WeatherModel>> groupByMonth(List<WeatherModel> weathers) {
//     Map<String, List<WeatherModel>> groupedData = {};
//     DateFormat monthFormatter = DateFormat.MMMM();
//     DateFormat formatter = DateFormat('MMM-yy');
//     weathers.forEach((weather) {
//       if (weather.timestamp != null) {
//
//         // String monthKey = "${weather.timestamp!.year}-${weather.timestamp!.month.toString().padLeft(2, '0')}";
//         // String monthKey = monthFormatter.format(weather.timestamp!);
//         String monthKey = formatter.format(weather.timestamp!);
//
//
//         groupedData.putIfAbsent(monthKey, () => []);
//         groupedData[monthKey]!.add(weather);
//       }
//     });
//
//
//     return groupedData;
//   }
//   List<double> calculateAverages(Map<String, List<WeatherModel>> dataMap, num? Function(WeatherModel) valueSelector) {
//     return dataMap.values.map((dataList) {
//
//       double sum = dataList.fold(0.0, (total, item) => total + (valueSelector(item) ?? 0));
//
//       return dataList.isNotEmpty ? sum / dataList.length : 0.0;
//     }).toList();
//   }