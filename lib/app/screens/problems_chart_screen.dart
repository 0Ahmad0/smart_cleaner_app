import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cleaner_app/app/screens/admin/home_admin_screen.dart';
import 'package:smart_cleaner_app/core/helpers/spacing.dart';
import 'package:smart_cleaner_app/core/utils/color_manager.dart';
import 'package:smart_cleaner_app/core/utils/style_manager.dart';
import 'package:smart_cleaner_app/core/widgets/app_padding.dart';

class ProblemsChartScreen extends StatefulWidget {
  @override
  _ProblemsChartScreenState createState() => _ProblemsChartScreenState();
}

class _ProblemsChartScreenState extends State<ProblemsChartScreen> {

  final Map<String, List<String>> problemsData = {
    'Location A': ['Problem 1', 'Problem 2', 'Problem 3'],
    'Location B': ['Problem 1', 'Problem 2'],
    'Location C': ['Problem 1', 'Problem 2', 'Problem 3', 'Problem 4'],
    'Location D': ['Problem 1'],
  };

  String? selectedLocation;

  @override
  Widget build(BuildContext context) {
    final locations = problemsData.keys.toList();
    final problemsCount = locations.map((loc) => problemsData[loc]!.length).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Problems Chart'),
        centerTitle: true,
      ),
      body: AppPaddingWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            verticalSpace(20.h),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: List.generate(
                    locations.length,
                        (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: problemsCount[index].toDouble(),
                          color: ColorManager.primaryColor,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                      showingTooltipIndicators: [0],
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < locations.length) {
                            return Transform.rotate(
                              angle: -0.45, // لجعل النص مائلًا
                              child: Text(
                                locations[value.toInt()],
                                style: StyleManager.font10Regular(),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        reservedSize: 34,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipMargin: 2,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${locations[group.x.toInt()]}:\n${rod.toY.toInt()} problems',
                          StyleManager.font10Regular(color: ColorManager.whiteColor),
                        );
                      },
                    ),
                    touchCallback: (FlTouchEvent event, BarTouchResponse? response) {
                      if (response != null &&
                          response.spot != null &&
                          event is FlTapUpEvent) {
                        final index = response.spot!.touchedBarGroupIndex;
                        setState(() {
                          selectedLocation = locations[index];
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            verticalSpace(10.h),
            Expanded(
              flex: 2,
              child: selectedLocation == null
                  ? Center(
                child: Text(
                  'Select a location from the chart to see its problems.',
                  style: StyleManager.font12Regular( color: ColorManager.hintTextColor),
                ),
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Problems in $selectedLocation:',
                    style: StyleManager.font12SemiBold(
                    ),
                  ),
                  verticalSpace(20.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: problemsData[selectedLocation]!.length,
                      itemBuilder: (context, index) {
                        final problem = problemsData[selectedLocation]![index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          leading: Icon(Icons.error, color: ColorManager.errorColor),
                          title: Text(problem),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
