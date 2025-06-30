import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/responsive/responsive_layout.dart';

class ConnectionStatusIndicator extends StatelessWidget {
  const ConnectionStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged.map((results) => results.isNotEmpty ? results.first : ConnectivityResult.none),
      builder: (context, snapshot) {
        final connected = snapshot.data != ConnectivityResult.none;

        final label = connected ? "Online" : "Offline";
        final color = connected ? AppColors.success : Colors.red;
        final glow = connected ? 1.0 : 0.0;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5 * glow),
                    blurRadius: 4 * glow,
                    spreadRadius: 2 * glow,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: ResponsiveHelper.getResponsiveTextStyle(
                context,
                AppStyles.bodySmall,
              ),
            ),
          ],
        );
      },
    );
  }
}
