import '../../../widgets/header_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Notifications extends StatelessWidget {
  Notifications({super.key});

  final List<Map<String, dynamic>> listnot = [
    {
      'imagesource': 'assets/notification_image/Layer 2.svg',
      'title': 'Hey, it’s time for lunch',
      'description': 'About 1 minute ago',
    },
    {
      'imagesource': 'assets/notification_image/alyer2.svg',
      'title': 'Don’t miss your lowerbody workout',
      'description': 'About 3 hours ago',
    },
    {
      'imagesource': 'assets/notification_image/pancakes.svg',
      'title': 'Hey, let’s add some meals for your b...',
      'description': 'About 3 minutes ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderBar(
                title: 'Notification',
                onIcon1Tap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.separated(
                  itemCount: listnot.length,
                  itemBuilder: (context, index) {
                    final notification = listnot[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              gradient: index % 2 == 0
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xff92A3FD),
                                        Color(0xff9AC1FE),
                                        Color(0xff9DCEFF),
                                      ],
                                    )
                                  : const LinearGradient(
                                      colors: [
                                        Color(
                                          0xff9c58bf2,
                                        ), // Note: Fix the invalid color code below
                                        Color(0xffEEA4CE),
                                      ],
                                    ),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                notification['imagesource'] ?? '',
                                height: 24,
                                width: 24,
                                placeholderBuilder: (context) => const Icon(
                                  Icons.broken_image,
                                  size: 24,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            // Wrap Column in Expanded to prevent overflow
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notification['title'] ?? 'No Title',
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notification['description'] ??
                                      'No Description',
                                  style: theme.textTheme.titleSmall!.copyWith(
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            FontAwesomeIcons.trash,
                            size: 16,
                            color: Colors.red.withValues(alpha: 0.8),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(color: Color(0xffDDDADA));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
