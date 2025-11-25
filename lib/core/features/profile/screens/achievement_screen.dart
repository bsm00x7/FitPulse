import 'package:flutter/material.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
          'Achievements',
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
          children: [
            // Summary Card
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffB4C0FE), Color(0xff9BB5FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffB4C0FE).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('15', 'Total\nBadges', Icons.emoji_events),
                  Container(height: 60, width: 1, color: Colors.white30),
                  _buildStatItem('8', 'Completed', Icons.check_circle),
                  Container(height: 60, width: 1, color: Colors.white30),
                  _buildStatItem('7', 'In Progress', Icons.trending_up),
                ],
              ),
            ),
            
            SizedBox(height: 30),
            
            // Achievement Categories
            _buildAchievementSection(
              'Steps Milestones',
              [
                _buildAchievementCard('First Steps', '1,000 steps', true, 0.8, Icons.directions_walk),
                _buildAchievementCard('Walking Star', '10,000 steps', true, 1.0, Icons.star),
                _buildAchievementCard('Marathon', '50,000 steps', false, 0.6, Icons.trending_up),
              ],
            ),
            
            SizedBox(height: 20),
            
            _buildAchievementSection(
              'Workout Streaks',
              [
                _buildAchievementCard('Consistency', '7 days streak', true, 1.0, Icons.local_fire_department),
                _buildAchievementCard('Dedicated', '30 days streak', false, 0.7, Icons.calendar_today),
                _buildAchievementCard('Champion', '100 days streak', false, 0.2, Icons.emoji_events),
              ],
            ),
            
            SizedBox(height: 20),
            
            _buildAchievementSection(
              'Goals Achieved',
              [
                _buildAchievementCard('Goal Getter', 'Complete 10 goals', true, 1.0, Icons.flag),
                _buildAchievementCard('Overachiever', 'Complete 50 goals', false, 0.4, Icons.military_tech),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  Widget _buildAchievementSection(String title, List<Widget> achievements) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff1D1617),
          ),
        ),
        SizedBox(height: 12),
        ...achievements,
      ],
    );
  }
  
  Widget _buildAchievementCard(String title, String description, bool isCompleted, double progress, IconData icon) {
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
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isCompleted 
                ? Color(0xffB4C0FE).withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isCompleted ? Color(0xffB4C0FE) : Colors.grey,
              size: 30,
            ),
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
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? Colors.green : Color(0xffB4C0FE),
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          if (isCompleted)
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 28,
            ),
        ],
      ),
    );
  }
}
