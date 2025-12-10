import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WorkoutProgressScreen extends StatelessWidget {
  const WorkoutProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xff1D1617)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Workout Progress',
          style: TextStyle(
            color: Color(0xff1D1617),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weekly Summary
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This Week',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1D1617),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildWeeklyStat('5', 'Workouts', Icons.fitness_center, Color(0xffB4C0FE)),
                      _buildWeeklyStat('240', 'Minutes', Icons.timer, Colors.orange),
                      _buildWeeklyStat('1,450', 'Calories', Icons.local_fire_department, Colors.red),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Weekly Activity Chart
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Activity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1D1617),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 100,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                                return Text(
                                  days[value.toInt()],
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 45, color: Color(0xffB4C0FE), width: 20, borderRadius: BorderRadius.circular(4))]),
                          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 60, color: Color(0xffB4C0FE), width: 20, borderRadius: BorderRadius.circular(4))]),
                          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 30, color: Color(0xffB4C0FE), width: 20, borderRadius: BorderRadius.circular(4))]),
                          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 75, color: Color(0xffB4C0FE), width: 20, borderRadius: BorderRadius.circular(4))]),
                          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 50, color: Color(0xffB4C0FE), width: 20, borderRadius: BorderRadius.circular(4))]),
                          BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 85, color: Color(0xffB4C0FE), width: 20, borderRadius: BorderRadius.circular(4))]),
                          BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 40, color: Color(0xffB4C0FE), width: 20, borderRadius: BorderRadius.circular(4))]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Recent Workouts
            Text(
              'Recent Workouts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff1D1617),
              ),
            ),
            SizedBox(height: 12),
            
            _buildWorkoutCard('Morning Run', 'Today, 7:00 AM', '45 min', '320 cal', Icons.directions_run, Color(0xffB4C0FE)),
            _buildWorkoutCard('Strength Training', 'Yesterday, 6:30 PM', '60 min', '450 cal', Icons.fitness_center, Colors.orange),
            _buildWorkoutCard('Yoga Session', '2 days ago, 8:00 AM', '30 min', '180 cal', Icons.self_improvement, Colors.green),
            _buildWorkoutCard('Cycling', '3 days ago, 5:00 PM', '40 min', '280 cal', Icons.directions_bike, Colors.purple),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWeeklyStat(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff1D1617),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
  
  Widget _buildWorkoutCard(String title, String time, String duration, String calories, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1D1617),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                duration,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1D1617),
                ),
              ),
              Text(
                calories,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
