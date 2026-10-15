
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/not_login_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/common/widgets/web/mobile_bottom_nav_bar.dart';
import 'package:flutter_grocery/common/widgets/web/web_header_widget.dart';
import 'package:flutter_grocery/common/widgets/web/web_category_drawer.dart';
import 'package:flutter_grocery/common/widgets/web/web_sidebar_menu.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/profile/widgets/profile_details_widget.dart';
import 'package:flutter_grocery/features/profile/widgets/profile_header_widget.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    if(_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(true, isUpdate: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const WebHeaderWidget() as PreferredSizeWidget
          : AppBar(
              backgroundColor: Theme.of(context).cardColor,
              leading: IconButton(
                  icon: Image.asset(Images.moreIcon, color: Theme.of(context).primaryColor),
                  onPressed: () {
                    splashProvider.setPageIndex(0);
                    Navigator.of(context).pop();
                  }),
              title: Text(getTranslated('profile', context),
                  style: poppinsMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  )),
            ),
      drawer: ResponsiveHelper.isDesktop(context) ? const WebCategoryDrawer() : null,
      endDrawer: ResponsiveHelper.isDesktop(context) ? const WebSidebarMenu() : null,
      bottomNavigationBar: const MobileBottomNavBar(currentIndex: 3),
      body: SafeArea(
        child: _isLoggedIn ? Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
            child: CustomScrollView(slivers: [
              SliverToBoxAdapter(child: ProfileHeaderWidget()),

              SliverToBoxAdapter(child: ProfileDetailsWidget()),

              FooterWebWidget(footerType: FooterType.sliver),
            ])
          );
        }) : const NotLoggedInWidget(),
      ),
    );
  }
}



