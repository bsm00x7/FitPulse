import 'dart:io';

import 'package:fitness/core/constant/storage_Key.dart';
import 'package:fitness/core/features/profile/widgets/show_model_bottom_sheet.dart';
import 'package:fitness/service/preference_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'controller/controller.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Enhanced color scheme
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color secondaryColor = Color(0xFF8B5CF6); // Purple
  static const Color accentColor = Color(0xFF06B6D4); // Cyan
  static const Color successColor = Color(0xFF10B981); // Emerald
  static const Color warningColor = Color(0xFFF59E0B); // Amber
  static const Color surfaceColor = Color(0xFFF8FAFC); // Light gray
  static const Color cardColor = Color(0xFFFFFFFF); // White
  static const Color gradientStart = Color(0xFF667EEA);
  static const Color gradientEnd = Color(0xFF764BA2);


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return ProfileController();
      },
      builder: (BuildContext context, Widget? child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [surfaceColor, Colors.white],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header with gradient background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [gradientStart, gradientEnd],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Logout button
                      Consumer<ProfileController>(
                        builder: (context, provider, child) {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  provider.signOut(context);
                                },
                                icon: Icon(
                                  Icons.logout_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Profile section
                      Row(
                        children: [
                          Consumer<ProfileController>(
                            builder: (context, provider, child) {
                              return GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return SizedBox(
                                        height: 200,
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 20,
                                            horizontal: 40,
                                          ),
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: provider.pickImageFromGallery,
                                                child: ListTile(
                                                  leading: Icon(
                                                    FontAwesomeIcons.image,
                                                  ),
                                                  title: Text(
                                                    'Pick Image From Gallery',
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                color: Colors.grey.withValues(
                                                  alpha: 0.5,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: provider.pickImageFromCamera,
                                                child: ListTile(
                                                  leading: Icon(
                                                    FontAwesomeIcons.camera,
                                                  ),
                                                  title: Text(
                                                    'Pick Image From Camera',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [accentColor, successColor],
                                    ),
                                  ),
                                  child: CircleAvatar(
                                      radius: 35,
                                      backgroundColor: Colors.white,
                                      child:provider.imageSource==
                                          null
                                          ? SvgPicture.asset(
                                        'assets/profile/user.svg',
                                        height: 32,
                                        colorFilter: ColorFilter.mode(
                                          primaryColor,
                                          BlendMode.srcIn,
                                        ),
                                      )
                                          : ClipOval(
                                        child: Image.file(
                                          File(provider.imageSource!),
                                          fit: BoxFit.cover,
                                          width: 35 * 2,
                                          height: 35 * 2,
                                        ),
                                      )
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 20),

                          // User info
                          Expanded(
                            child: Consumer<ProfileController>(
                              builder:
                                  (BuildContext context, value, Widget? child) {
                                return Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      value.userName ?? 'user not found',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          20,
                                        ),
                                      ),
                                      child: Text(
                                        value.userGoal!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                          // Edit button with enhanced styling
                          Consumer<ProfileController>(
                            builder: (context, provider, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [accentColor, successColor],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: accentColor.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    buildShowModalBottomSheetWidget(
                                      context: context,
                                      usernameController:
                                      provider.usernameController,
                                      key: provider.key,
                                      onPressed: () async {
                                        provider.updateUserInformation(
                                          context: context,
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    minimumSize: Size(80, 40),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),

                SizedBox(height: 30),

                // Stats boxes with enhanced colors
                Consumer<ProfileController>(
                  builder: (BuildContext context, value, Widget? child) {
                    return Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  primaryColor.withValues(alpha: 0.1),
                                  primaryColor.withValues(alpha: 0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: primaryColor.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '${value.height}cm',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                Text(
                                  'Height',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  successColor.withValues(alpha: 0.1),
                                  successColor.withValues(alpha: 0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: successColor.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '${value.weight}Kg',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: successColor,
                                  ),
                                ),
                                Text(
                                  'Weight',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 40),

                // Account section
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Account',
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildEnhancedListTile(
                            'assets/profile/Icon-Profile.svg',
                            'Personal Data',
                            primaryColor,
                            isFirst: true,
                          ),
                          _buildDivider(),
                          _buildEnhancedListTile(
                            'assets/profile/Icon-Achievement.svg',
                            'Achievement',
                            warningColor,
                          ),
                          _buildDivider(),
                          _buildEnhancedListTile(
                            'assets/profile/Icon-Activity.svg',
                            'Activity History',
                            accentColor,
                          ),
                          _buildDivider(),
                          _buildEnhancedListTile(
                            'assets/profile/Icon-Workout.svg',
                            'Workout Progress',
                            successColor,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Notification section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Notification',
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: secondaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SvgPicture.asset(
                            'assets/profile/Notification.svg',
                            colorFilter: ColorFilter.mode(
                              secondaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        title: Text(
                          'Pop-up Notification',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        trailing: Switch.adaptive(
                          value: true,
                          onChanged: (value) {},
                          activeColor: successColor,
                          activeTrackColor: successColor.withValues(alpha: 0.3),
                          inactiveThumbColor: Colors.grey[400],
                          inactiveTrackColor: Colors.grey[300],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Other section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Other',
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildEnhancedListTile(
                            'assets/profile/Message.svg',
                            'Contact Us',
                            accentColor,
                            isFirst: true,
                          ),
                          _buildDivider(),
                          _buildEnhancedListTile(
                            'assets/profile/Setting.svg',
                            'Settings',
                            Colors.grey[600]!,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedListTile(String iconPath,
      String title,
      Color iconColor, {
        bool isFirst = false,
        bool isLast = false,
      }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SvgPicture.asset(
          iconPath,
          height: 20,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[800]),
      ),
      trailing: Container(
        padding: EdgeInsets.all(4),
        child: SvgPicture.asset(
          'assets/profile/Icon-Arrow.svg',
          height: 16,
          colorFilter: ColorFilter.mode(Colors.grey[400]!, BlendMode.srcIn),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2)),
    );
  }
}
