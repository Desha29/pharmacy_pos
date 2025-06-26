import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/theme/text_styles.dart';
import '../../data/models/quick_action.dart';
import '../../data/models/stat_item.dart';
import '../widgets/animated_page_transition.dart';
import 'stat_card.dart';
import 'quick_action_button.dart';

class DashboardContent extends StatefulWidget {
  final Function(String) onNavigate;

  const DashboardContent({super.key, required this.onNavigate});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  late List<Animation<double>> _cardAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _cardAnimations = List.generate(4, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(
            index * 0.1,
            0.4 + (index * 0.1),
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });

    _slideAnimations = List.generate(4, (index) {
      return Tween<Offset>(
        begin: const Offset(0.0, 0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(
            index * 0.1,
            0.4 + (index * 0.1),
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });

    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.getScreenPadding(context);
    final stats = [
      const StatItem(
        title: "Today's Sales",
        value: "\$2,847.50",
        change: "+12.5%",
        iconPath:
            "M12 2L13.09 8.26L22 9L13.09 9.74L12 16L10.91 9.74L2 9L10.91 8.26L12 2Z",
        isPositive: true,
      ),
      const StatItem(
        title: "Prescriptions",
        value: "156",
        change: "+8.2%",
        iconPath:
            "M19 3H5C3.9 3 3 3.9 3 5V19C3 20.1 3.9 21 5 21H19C20.1 21 21 20.1 21 19V5C21 3.9 20.1 3 19 3ZM19 19H5V5H19V19Z",
        isPositive: true,
      ),
      const StatItem(
        title: "Low Stock Items",
        value: "23",
        change: "-5.1%",
        iconPath:
            "M12 2L13.09 8.26L22 9L13.09 9.74L12 16L10.91 9.74L2 9L10.91 8.26L12 2Z",
        isPositive: false,
      ),
      const StatItem(
        title: "Active Customers",
        value: "1,247",
        change: "+15.3%",
        iconPath:
            "M16 4C18.2 4 20 5.8 20 8S18.2 12 16 12S12 10.2 12 8S13.8 4 16 4ZM16 14C20.4 14 24 15.8 24 18V20H8V18C8 15.8 11.6 14 16 14Z",
        isPositive: true,
      ),
    ];

    final quickActions = [
      const QuickAction(
        label: "New Sale",
        iconPath:
            "M7 4V2C7 1.45 7.45 1 8 1H16C16.55 1 17 1.45 17 2V4H20C20.55 4 21 4.45 21 5S20.55 6 20 6H19V19C19 20.1 18.1 21 17 21H7C5.9 21 5 20.1 5 19V6H4C3.45 6 3 5.55 3 5S3.45 4 4 4H7Z",
        action: "sales",
      ),
      const QuickAction(
        label: "Add Inventory",
        iconPath: "M19 13H13V19H11V13H5V11H11V5H13V11H19V13Z",
        action: "inventory",
      ),
      const QuickAction(
        label: "Generate Invoice",
        iconPath:
            "M14 2H6C4.9 2 4 2.9 4 4V20C4 21.1 4.89 22 5.99 22H18C19.1 22 20 21.1 20 20V8L14 2Z",
        action: "invoices",
      ),
      const QuickAction(
        label: "Sync Data",
        iconPath:
            "M12 4V1L8 5L12 9V6C15.31 6 18 8.69 18 12C18 13.01 17.75 13.97 17.3 14.8L18.76 16.26C19.54 15.03 20 13.57 20 12C20 7.58 16.42 4 12 4Z",
        action: "sync",
      ),
    ];

    return SingleChildScrollView(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics Grid with Staggered Animation
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveHelper.getGridColumns(context),
              crossAxisSpacing: ResponsiveHelper.isMobile(context) ? 16 : 20,
              mainAxisSpacing: ResponsiveHelper.isMobile(context) ? 16 : 20,
              childAspectRatio: ResponsiveHelper.getCardAspectRatio(context),
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _staggerController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _cardAnimations[index],
                    child: SlideTransition(
                      position: _slideAnimations[index],
                      child: StatCard(stat: stats[index], index: index),
                    ),
                  );
                },
              );
            },
          ),

          SizedBox(height: ResponsiveHelper.isMobile(context) ? 20 : 24),

          // Quick Actions Section with Animation
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: Container(
                    decoration: AppStyles.cardDecoration,
                    padding: EdgeInsets.all(
                      ResponsiveHelper.isMobile(context) ? 20 : 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quick Actions",
                          style: ResponsiveHelper.getResponsiveTextStyle(
                            context,
                            AppStyles.heading3,
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveHelper.isMobile(context) ? 16 : 20,
                        ),
                        StaggeredAnimationWrapper(
                          delay: const Duration(milliseconds: 150),
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        ResponsiveHelper.getQuickActionColumns(
                                          context,
                                        ),
                                    crossAxisSpacing:
                                        ResponsiveHelper.isMobile(context)
                                        ? 12
                                        : 16,
                                    mainAxisSpacing:
                                        ResponsiveHelper.isMobile(context)
                                        ? 12
                                        : 16,
                                    childAspectRatio:
                                        ResponsiveHelper.getQuickActionAspectRatio(
                                          context,
                                        ),
                                  ),
                              itemCount: quickActions.length,
                              itemBuilder: (context, index) =>
                                  QuickActionButton(
                                    action: quickActions[index],
                                    onTap: () => widget.onNavigate(
                                      quickActions[index].action,
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
