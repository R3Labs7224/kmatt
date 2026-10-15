import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/responsive_dimensions.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/theme/app_colors.dart';
import 'package:flutter_grocery/theme/app_text_styles.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:provider/provider.dart';

/// Modern web header with blue background - Fully responsive
class WebHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  const WebHeaderWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(170);

  @override
  Widget build(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final useMobileLayout = ResponsiveDimensions.shouldUseMobileLayout(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // More robust responsive dimensions to prevent overflow
    final logoWidth = _getLogoWidth(screenWidth, useMobileLayout);
    final logoHeight = _getLogoHeight(screenWidth, useMobileLayout);
    final searchWidth = useMobileLayout ? double.infinity : _getSearchWidth(screenWidth);
    final searchHeight = ResponsiveDimensions.height(context, 52).clamp(40.0, 52.0);
    final buttonSize = _getButtonSize(screenWidth);
    final horizontalPadding = ResponsiveDimensions.getHorizontalPadding(context);

    return Column(
        children: [
          // Main header - Logo, Search, Actions
          Container(
            decoration: BoxDecoration(
        color: AppColors.webPrimaryBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: ResponsiveDimensions.padding(context, 12),
              ),
              child: useMobileLayout
                  ? _buildMobileHeader(context, splashProvider, authProvider, logoWidth, logoHeight, searchHeight)
                  : _buildDesktopHeader(context, splashProvider, authProvider, logoWidth, logoHeight, searchWidth, searchHeight, buttonSize, horizontalPadding),
            ),
          ),

          // Bottom navigation bar - simplified (hide on mobile)
          if (!useMobileLayout)
            Container(
              margin: EdgeInsets.only(bottom: ResponsiveDimensions.padding(context, 24)),
              decoration: BoxDecoration(
                color: Colors.purple[100], // Purple 100 background
              ),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: ResponsiveDimensions.padding(context, 6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side - All Categories button - Opens category drawer (left)
                  TextButton.icon(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: Icon(
                      Icons.category_outlined,
                      size: ResponsiveDimensions.scale(context, 20),
                      color: Colors.black,
                    ),
                    label: Text(
                      'All Categories',
                      style: TextStyle(
                        fontSize: ResponsiveDimensions.fontSize(context, 15),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveDimensions.padding(context, 16),
                        vertical: ResponsiveDimensions.padding(context, 8),
                      ),
                    ),
                  ),

                  // Right side - About Us
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(RouteHelper.getAboutUsRoute());
                    },
                    child: Text(
                      'About Us',
                      style: TextStyle(
                        fontSize: ResponsiveDimensions.fontSize(context, 15),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],

    );
  }

  // Desktop/Tablet header layout
  Widget _buildDesktopHeader(
    BuildContext context,
    SplashProvider splashProvider,
    AuthProvider authProvider,
    double logoWidth,
    double logoHeight,
    double searchWidth,
    double searchHeight,
    double buttonSize,
    double horizontalPadding,
  ) {
    return Row(
      children: [
        // Logo - Flexible to prevent overflow
        Flexible(
          flex: 0,
          child: Padding(
            padding: EdgeInsets.only(left: horizontalPadding),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(RouteHelper.menu);
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: logoWidth,
                  minWidth: logoWidth * 0.7, // Allow shrinking to 70% if needed
                ),
                height: logoHeight,
                padding: EdgeInsets.symmetric(horizontal: ResponsiveDimensions.padding(context, 8)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: splashProvider.configModel?.ecommerceLogo != null && splashProvider.baseUrls != null
                        ? Image.network(
                            '${splashProvider.baseUrls!.ecommerceImageUrl}/${splashProvider.configModel!.ecommerceLogo!}',
                            height: logoHeight * 0.8, // Slightly smaller to fit container
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              Images.appLogo,
                              height: logoHeight * 0.8,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Image.asset(
                            Images.appLogo,
                            height: logoHeight * 0.8,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),

        const Spacer(),

        // Search Bar - Flexible to take available space
        Flexible(
          flex: 1,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: searchWidth,
              minWidth: searchWidth < 300 ? searchWidth : 300, // Prevent invalid constraints
            ),
            height: searchHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(searchHeight / 2),
            ),
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: 'Search For Groceries...',
                hintStyle: TextStyle(
                  color: AppColors.webPrimaryBlue,
                  fontSize: ResponsiveDimensions.fontSize(context, 15),
                ),
                suffixIcon: Icon(
                  Icons.search,
                  color: AppColors.webPrimaryBlue,
                  size: ResponsiveDimensions.scale(context, 24),
                ),
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ResponsiveDimensions.padding(context, 24),
                  vertical: 0,
                ),
                isDense: true,
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  Navigator.of(context).pushNamed(RouteHelper.searchProduct, arguments: value);
                }
              },
            ),
          ),
        ),

        SizedBox(width: ResponsiveDimensions.padding(context, 24)),

        // Action buttons
        Row(
          children: [
            // Sign In button
            if (!authProvider.isLoggedIn())
              Container(
                height: buttonSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(buttonSize / 2),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteHelper.login);
                  },
                  icon: Icon(
                    Icons.person_outline,
                    size: ResponsiveDimensions.scale(context, 20),
                    color: AppColors.webPrimaryBlue,
                  ),
                  label: Text(
                    'Sign In',
                    style: TextStyle(
                      color: AppColors.webPrimaryBlue,
                      fontSize: ResponsiveDimensions.fontSize(context, 15),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveDimensions.padding(context, 20),
                      vertical: ResponsiveDimensions.padding(context, 8),
                    ),
                  ),
                ),
              )
            else
              Container(
                width: buttonSize,
                height: buttonSize,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.person, color: AppColors.webPrimaryBlue),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteHelper.profile);
                  },
                ),
              ),

            SizedBox(width: ResponsiveDimensions.padding(context, 12)),

            // Cart button
            _CartButton(buttonSize: buttonSize),

            SizedBox(width: ResponsiveDimensions.padding(context, 12)),

            // Hamburger Menu Icon
            Container(
              width: buttonSize,
              height: buttonSize,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: Icon(
                  Icons.menu,
                  color: AppColors.webPrimaryBlue,
                  size: ResponsiveDimensions.scale(context, 24),
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Mobile header layout
  Widget _buildMobileHeader(
    BuildContext context,
    SplashProvider splashProvider,
    AuthProvider authProvider,
    double logoWidth,
    double logoHeight,
    double searchHeight,
  ) {
    return Column(
      children: [
        // Top row: Logo, Cart, Menu
        Row(
          children: [
            // Logo (smaller on mobile)
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(RouteHelper.menu);
              },
              child: Container(
                width: logoWidth * 0.7,
                height: logoHeight * 0.7,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: splashProvider.configModel?.ecommerceLogo != null && splashProvider.baseUrls != null
                        ? Image.network(
                            '${splashProvider.baseUrls!.ecommerceImageUrl}/${splashProvider.configModel!.ecommerceLogo!}',
                            height: logoHeight * 0.7,
                            errorBuilder: (context, error, stackTrace) => Image.asset(Images.appLogo, height: logoHeight * 0.7),
                          )
                        : Image.asset(Images.appLogo, height: logoHeight * 0.7),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Cart and Menu icons
            Row(
              children: [
                _CartButton(buttonSize: 40),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: AppColors.webPrimaryBlue,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Search bar (full width on mobile)
        Container(
          width: double.infinity,
          height: searchHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(searchHeight / 2),
          ),
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: const TextStyle(
                color: AppColors.webPrimaryBlue,
                fontSize: 14,
              ),
              suffixIcon: const Icon(
                Icons.search,
                color: AppColors.webPrimaryBlue,
                size: 20,
              ),
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              isDense: true,
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                Navigator.of(context).pushNamed(RouteHelper.searchProduct, arguments: value);
              }
            },
          ),
        ),
      ],
    );
  }

  // Helper methods for robust responsive sizing to prevent overflow
  static double _getLogoWidth(double screenWidth, bool useMobileLayout) {
    if (useMobileLayout) {
      return screenWidth * 0.25; // 25% of screen on mobile
    }
    // Desktop/Tablet - adaptive sizing
    if (screenWidth >= 1300) return 160.0; // Full size on desktop
    if (screenWidth >= 1024) return 140.0; // Laptop
    if (screenWidth >= 900) return 120.0;  // Small laptop
    if (screenWidth >= 768) return 100.0;  // Tablet
    return 90.0;
  }

  static double _getLogoHeight(double screenWidth, bool useMobileLayout) {
    if (useMobileLayout) {
      return 45.0; // Fixed smaller height on mobile
    }
    // Desktop/Tablet - proportional to width
    if (screenWidth >= 1300) return 60.0;
    if (screenWidth >= 1024) return 52.0;
    if (screenWidth >= 900) return 48.0;
    if (screenWidth >= 768) return 42.0;
    return 40.0;
  }

  static double _getSearchWidth(double screenWidth) {
    // Search bar takes available space with constraints
    if (screenWidth >= 1300) return 600.0; // Max width on desktop
    if (screenWidth >= 1024) return screenWidth * 0.45; // 45% on laptop
    if (screenWidth >= 900) return screenWidth * 0.40;  // 40% on small laptop
    if (screenWidth >= 768) return screenWidth * 0.35;  // 35% on tablet
    return 400.0; // Minimum width
  }

  static double _getButtonSize(double screenWidth) {
    if (screenWidth >= 1300) return 48.0;
    if (screenWidth >= 1024) return 44.0;
    if (screenWidth >= 900) return 40.0;
    if (screenWidth >= 768) return 38.0;
    return 36.0;
  }
}

class _CartButton extends StatelessWidget {
  final double buttonSize;

  const _CartButton({required this.buttonSize});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Container(
          width: buttonSize,
          height: buttonSize,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: AppColors.webPrimaryBlue,
                    size: buttonSize * 0.46, // Proportional icon size
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteHelper.cart);
                  },
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(buttonSize * 0.08),
                  decoration: const BoxDecoration(
                    color: AppColors.webPrimaryBlue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  constraints: BoxConstraints(
                    minWidth: buttonSize * 0.375,
                    minHeight: buttonSize * 0.375,
                  ),
                  child: Center(
                    child: Text(
                      '${cartProvider.cartList.length}',
                      style: AppTextStyles.webOverline.copyWith(
                        color: Colors.white,
                        fontSize: (buttonSize * 0.21).clamp(8, 12),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
