import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';

class WeatherChartScreen extends StatefulWidget {
  @override
  _WeatherChartScreenState createState() => _WeatherChartScreenState();
}

class _WeatherChartScreenState extends State<WeatherChartScreen> {
  bool isWeekly = true;

  final weeklyData = [15, 18, 20, 22, 19];
  final monthlyData = [15, 16, 18, 20, 19, 17, 16];

  @override
  Widget build(BuildContext context) {
    final data = isWeekly ? weeklyData : monthlyData;

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
                      spots: List.generate(data.length,
                              (index) => FlSpot(index.toDouble(), data[index].toDouble())),
                      isCurved: true,
                      color: ColorManager.primaryColor,
                      barWidth: 2,
                      belowBarData: BarAreaData(
                        show: true,
                        color: ColorManager.primaryColor.withOpacity(0.3),
                      ),
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
                          int index = value.toInt();
                          if (index >= 0 && index < data.length) {
                            return Text(
                              isWeekly
                                  ? 'Day ${index + 1}'
                                  : 'Day ${index + 1}', // تعديل النص حسب الحاجة
                              style: StyleManager.font10Medium()
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
            ),
          ],
        ),
      ),
    );
  }
}
