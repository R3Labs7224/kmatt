import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/menu/domain/models/menu_model.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/theme/app_colors.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:provider/provider.dart';

/// Modern web sidebar menu with blue theme and fade-in animation
class WebSidebarMenu extends StatefulWidget {
  const WebSidebarMenu({super.key});

  @override
  State<WebSidebarMenu> createState() => _WebSidebarMenuState();
}

class _WebSidebarMenuState extends State<WebSidebarMenu> with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Start fade-in animation after a brief delay
    Future.microtask(() {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);

    final List<MenuModel> menuList = [
      MenuModel(icon: Images.list, title: getTranslated('all_categories', context), route: RouteHelper.categories),
      MenuModel(icon: Images.orderList, title: getTranslated('my_order', context), route: RouteHelper.orderListScreen),
      MenuModel(icon: Images.trackOrder, title: getTranslated('order_track', context), route: RouteHelper.orderSearchScreen),
      MenuModel(icon: Images.editProfile, title: getTranslated('profile', context), route: isLoggedIn ? RouteHelper.profile : RouteHelper.getLoginRoute()),
      MenuModel(icon: Images.addressList, title: getTranslated('address', context), route: RouteHelper.address),
      MenuModel(icon: Images.coupon, title: getTranslated('coupon', context), route: RouteHelper.coupon),
      MenuModel(icon: Images.notification, title: getTranslated('notification', context), route: RouteHelper.notification),

      if (splashProvider.configModel?.walletStatus ?? false)
        MenuModel(icon: Images.wallet, title: getTranslated('wallet', context), route: RouteHelper.getWalletRoute()),

      if (splashProvider.configModel?.loyaltyPointStatus ?? false)
        MenuModel(icon: Images.loyaltyPoint, title: getTranslated('loyalty_point', context), route: RouteHelper.getLoyaltyScreen()),

      MenuModel(icon: Images.message, title: getTranslated('contact_us', context), route: RouteHelper.getContactRoute()),
      MenuModel(icon: Images.privacyPolicy, title: getTranslated('privacy_policy', context), route: RouteHelper.getPolicyRoute()),
      MenuModel(icon: Images.termsAndConditions, title: getTranslated('terms_and_condition', context), route: RouteHelper.getTermsRoute()),
      MenuModel(icon: Images.aboutUs, title: getTranslated('about_us', context), route: RouteHelper.getAboutUsRoute()),
      MenuModel(icon: isLoggedIn ? Images.logOut : Images.logIn, title: getTranslated(isLoggedIn ? 'log_out' : 'login', context), route: 'auth'),
    ];

    return Drawer(
      width: 350,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.webDarkCard
          : Colors.white,
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Column(
          children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
            child: Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                return Column(
                  children: [
                    // Close button
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 24),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Profile Image
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: isLoggedIn
                            ? CustomImageWidget(
                                placeholder: Images.placeHolder,
                                image: splashProvider.baseUrls != null
                                    ? '${splashProvider.baseUrls!.customerImageUrl}/${profileProvider.userInfoModel?.image ?? ''}'
                                    : '',
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              )
                            : const CustomAssetImageWidget(
                                Images.placeHolder,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // User Name
                    Text(
                      isLoggedIn
                          ? (profileProvider.userInfoModel != null
                              ? '${profileProvider.userInfoModel!.fName ?? ''} ${profileProvider.userInfoModel!.lName ?? ''}'
                              : 'Loading...')
                          : getTranslated('guest', context),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    if (isLoggedIn && profileProvider.userInfoModel != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        profileProvider.userInfoModel!.email ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                );
              },
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: menuList.length,
              itemBuilder: (context, index) {
                return _MenuItemWidget(menu: menuList[index]);
              },
            ),
          ),

          // Delete Account Button (if logged in)
          if (isLoggedIn)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: TextButton.icon(
                onPressed: () {
                  // TODO: Implement delete account dialog
                },
                icon: Icon(Icons.delete_outline, size: 20, color: Colors.red.shade700),
                label: Text(
                  getTranslated('delete_account', context),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: Colors.red.shade700,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItemWidget extends StatefulWidget {
  final MenuModel menu;

  const _MenuItemWidget({required this.menu});

  @override
  State<_MenuItemWidget> createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<_MenuItemWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isLogout = widget.menu.route == 'auth';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {
          Navigator.pop(context); // Close drawer

          if (isLogout) {
            final isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
            if (isLoggedIn) {
              // Logout
              Provider.of<AuthProvider>(context, listen: false).clearSharedData().then((value) {
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.getLoginRoute(), (route) => false);
                }
              });
            } else {
              // Login
              Navigator.of(context).pushNamed(RouteHelper.login);
            }
          } else if (widget.menu.route != null) {
            Navigator.of(context).pushNamed(widget.menu.route!);
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.webPrimaryBlue.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              // Icon
              CustomAssetImageWidget(
                widget.menu.icon,
                width: 22,
                height: 22,
                color: _isHovered ? AppColors.webPrimaryBlue : Colors.grey.shade700,
              ),

              const SizedBox(width: 16),

              // Title
              Expanded(
                child: Text(
                  widget.menu.title ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: _isHovered ? AppColors.webPrimaryBlue : Colors.black87,
                  ),
                ),
              ),

              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: _isHovered ? AppColors.webPrimaryBlue : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
