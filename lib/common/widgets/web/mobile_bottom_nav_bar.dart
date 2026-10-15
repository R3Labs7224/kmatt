import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_dimensions.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/theme/app_colors.dart';

/// Bottom navigation bar for mobile screens on the web platform
class MobileBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const MobileBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Only show on mobile layout
    if (!ResponsiveDimensions.shouldUseMobileLayout(context)) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.webDarkCard
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: ResponsiveDimensions.height(context, 110),
            maxHeight: ResponsiveDimensions.height(context, 110),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveDimensions.padding(context, 13),
              vertical: ResponsiveDimensions.padding(context, 8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.home,
                  activeIcon: Icons.home,
                  label: getTranslated('home', context),
                  index: 0,
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteHelper.menu,
                      (route) => false,
                    );
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.grid_view,
                  activeIcon: Icons.grid_view,
                  label: getTranslated('all_categories', context),
                  index: 1,
                  onTap: () {
                    Navigator.of(context).pushNamed(RouteHelper.categories);
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.shopping_cart,
                  activeIcon: Icons.shopping_cart,
                  label: getTranslated('cart', context),
                  index: 2,
                  onTap: () {
                  Navigator.of(context).pushNamed(RouteHelper.cart);
                  },
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.person,
                  activeIcon: Icons.person,
                  label: getTranslated('profile', context),
                  index: 3,
                  onTap: () {
                    Navigator.of(context).pushNamed(RouteHelper.profile);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    final isActive = currentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, 21)), // 16 * 1.3 ≈ 21
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveDimensions.padding(context, 6), // Reduced to prevent overflow
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: isActive ? 1.0 : 0.6,
                child: Icon(
                  isActive ? activeIcon : icon,
                  size: ResponsiveDimensions.scale(context, 40), // 31 * 1.3 ≈ 40
                  color: isActive
                      ? AppColors.webPrimaryBlue
                      : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                ),
              ),
              SizedBox(height: ResponsiveDimensions.padding(context, 4)), // Reduced spacing
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.fontSize(context, 12), // Made smaller
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.w400, // Less bold
                    fontFamily: 'Poppins',
                    color: isActive
                        ? AppColors.webPrimaryBlue
                        : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
