import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_layout.dart';
import '../../../../core/theme/text_styles.dart';
import '../../data/models/quick_action.dart';
import '../../data/models/stat_item.dart';
import 'animated_page_transition.dart';
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
           "assets/images/cart.png",
        isPositive: true,
      ),
      const StatItem(
        title: "Prescriptions",
        value: "156",
        change: "+8.2%",
      iconPath: "assets/images/inventory.png",
        isPositive: true,
      ),
      const StatItem(
        title: "Low Stock Items",
        value: "23",
        change: "-5.1%",
        iconPath: "assets/images/inventory1.png",
        isPositive: false,
      ),

    ];

    final quickActions = [
      const QuickAction(
        label: "New Sale",
        iconPath:
           "assets/images/cart.png",
        action: "sales",
      ),
      const QuickAction(
        label: "Inventory",
        iconPath: "assets/images/inventory1.png",
        action: "inventory",
      ),
      const QuickAction(
        label: "Invoices",
        iconPath:
            "assets/images/bill.png",
        action: "invoices",
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
              crossAxisSpacing: ResponsiveHelper.isMobile(context) ? 16 : 32,
              mainAxisSpacing: ResponsiveHelper.isMobile(context) ? 16 : 32,
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

          SizedBox(height: ResponsiveHelper.isMobile(context) ? 20 : 32),

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
                      ResponsiveHelper.isMobile(context) ? 20 : 32,
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
                          height: ResponsiveHelper.isMobile(context) ? 16 : 32,
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
                                        : 32,
                                    mainAxisSpacing:
                                        ResponsiveHelper.isMobile(context)
                                        ? 12
                                        : 32,
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
