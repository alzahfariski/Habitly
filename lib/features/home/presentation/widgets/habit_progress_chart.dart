import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_color.dart';
import '../providers/habit_provider.dart';

class HabitProgressChart extends ConsumerWidget {
  const HabitProgressChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitState = ref.watch(habitProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (habitState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (habitState.habits.isEmpty) {
      return const SizedBox.shrink(); // Hide chart if no habits exist
    }

    // Prepare data for the last 7 days
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final last7Days = List.generate(
      7,
      (index) => today.subtract(Duration(days: 6 - index)),
    );

    List<BarChartGroupData> barGroups = [];
    int maxY = 0;

    for (int i = 0; i < last7Days.length; i++) {
      final date = last7Days[i];
      // Find completed habits on this date
      final completedCount = habitState.habits.where((h) {
        final matchesDate =
            h.date.year == date.year &&
            h.date.month == date.month &&
            h.date.day == date.day;
        return matchesDate && h.isCompleted;
      }).length;

      if (completedCount > maxY) {
        maxY = completedCount;
      }

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: completedCount.toDouble(),
              gradient: const LinearGradient(
                colors: [AppColors.primary400, AppColors.primary600],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              width: 12,
              borderRadius: BorderRadius.circular(4),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: (maxY > 5 ? maxY : 5)
                    .toDouble(), // minimum background height
                color: isDark ? AppColors.neutral700 : Colors.grey[200],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withAlpha(50)
                : Colors.grey.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Progress',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.neutral200 : Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                maxY: (maxY > 5 ? maxY : 5).toDouble(),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) =>
                        isDark ? AppColors.neutral700 : Colors.blueGrey,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toInt()} completed',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        return value % 1 == 0
                            ? Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.neutral400
                                      : Colors.grey,
                                  fontSize: 10,
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final date = last7Days[value.toInt()];
                        final isToday =
                            date.day == today.day && date.month == today.month;
                        final days = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            isToday ? 'Today' : days[date.weekday - 1],
                            style: TextStyle(
                              color: isToday
                                  ? AppColors.primary500
                                  : (isDark
                                        ? AppColors.neutral400
                                        : Colors.grey),
                              fontWeight: isToday
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: isDark
                        ? AppColors.neutral700
                        : Colors.grey.withAlpha(50),
                    strokeWidth: 1,
                  ),
                ),
                barGroups: barGroups,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
