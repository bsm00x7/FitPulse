import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pushNotifications = true;
  bool emailNotifications = false;
  bool darkMode = false;
  String measurementUnit = 'metric';
  
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
          'Settings',
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
            // Notifications Section
            _buildSectionTitle('Notifications'),
            SizedBox(height: 12),
            Container(
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
              child: Column(
                children: [
                  _buildSwitchTile(
                    'Push Notifications',
                    'Receive push notifications for workouts',
                    pushNotifications,
                    Icons.notifications_active,
                    (value) => setState(() => pushNotifications = value),
                  ),
                  Divider(height: 1, indent: 70),
                  _buildSwitchTile(
                    'Email Notifications',
                    'Receive weekly progress reports',
                    emailNotifications,
                    Icons.email,
                    (value) => setState(() => emailNotifications = value),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Appearance Section
            _buildSectionTitle('Appearance'),
            SizedBox(height: 12),
            Container(
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
              child: _buildSwitchTile(
                'Dark Mode',
                'Enable dark theme',
                darkMode,
                Icons.dark_mode,
                (value) => setState(() => darkMode = value),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Units Section
            _buildSectionTitle('Units'),
            SizedBox(height: 12),
            Container(
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
              child: Column(
                children: [
                  _buildRadioTile(
                    'Metric (kg, km)',
                    measurementUnit == 'metric',
                    Icons.straighten,
                    () => setState(() => measurementUnit = 'metric'),
                  ),
                  Divider(height: 1, indent: 70),
                  _buildRadioTile(
                    'Imperial (lb, mi)',
                    measurementUnit == 'imperial',
                    Icons.straighten,
                    () => setState(() => measurementUnit = 'imperial'),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Data & Privacy Section
            _buildSectionTitle('Data & Privacy'),
            SizedBox(height: 12),
            Container(
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
              child: Column(
                children: [
                  _buildActionTile('Privacy Policy', Icons.privacy_tip, () {}),
                  Divider(height: 1, indent: 70),
                  _buildActionTile('Terms of Service', Icons.description, () {}),
                  Divider(height: 1, indent: 70),
                  _buildActionTile('Clear Cache', Icons.cleaning_services, () {
                    _showClearCacheDialog();
                  }),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // About Section
            _buildSectionTitle('About'),
            SizedBox(height: 12),
            Container(
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
              child: Column(
                children: [
                  _buildActionTile('App Version', Icons.info_outline, () {}, trailing: '1.0.0'),
                  Divider(height: 1, indent: 70),
                  _buildActionTile('Rate Us', Icons.star_outline, () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xff1D1617),
      ),
    );
  }
  
  Widget _buildSwitchTile(String title, String subtitle, bool value, IconData icon, Function(bool) onChanged) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xffB4C0FE).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Color(0xffB4C0FE)),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xff1D1617),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: Color(0xffB4C0FE),
      ),
    );
  }
  
  Widget _buildRadioTile(String title, bool selected, IconData icon, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xffB4C0FE).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Color(0xffB4C0FE)),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xff1D1617),
        ),
      ),
      trailing: Radio<bool>(
        value: true,
        groupValue: selected,
        onChanged: (_) => onTap(),
        activeColor: Color(0xffB4C0FE),
      ),
      onTap: onTap,
    );
  }
  
  Widget _buildActionTile(String title, IconData icon, VoidCallback onTap, {String? trailing}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xffB4C0FE).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Color(0xffB4C0FE)),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xff1D1617),
        ),
      ),
      trailing: trailing != null 
        ? Text(
            trailing,
            style: TextStyle(color: Colors.grey[600]),
          )
        : Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
      onTap: onTap,
    );
  }
  
  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Clear Cache'),
        content: Text('Are you sure you want to clear the cache? This will remove temporary files.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffB4C0FE),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }
}
