import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/data_source_enum.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/providers/product_provider.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/web/mobile_bottom_nav_bar.dart';
import 'package:flutter_grocery/common/widgets/web/web_sidebar_menu.dart';
import 'package:flutter_grocery/common/widgets/web/web_category_drawer.dart';
import 'package:flutter_grocery/common/widgets/web/web_header_widget.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/category/providers/category_provider.dart';
import 'package:flutter_grocery/features/home/providers/banner_provider.dart';
import 'package:flutter_grocery/features/home/providers/flash_deal_provider.dart';
import 'package:flutter_grocery/features/home/widgets/web/web_banner_widget.dart';
import 'package:flutter_grocery/features/home/widgets/web/web_category_circles_widget.dart';
import 'package:flutter_grocery/features/home/widgets/web/web_product_section_widget.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/features/wishlist/providers/wishlist_provider.dart';
import 'package:flutter_grocery/helper/responsive_dimensions.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/theme/app_colors.dart';
import 'package:flutter_grocery/utill/product_type.dart';
import 'package:provider/provider.dart';

/// Web-specific home screen - Fully responsive
/// This is completely separate from the mobile home screen
class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({super.key});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData(false);
      Provider.of<OrderProvider>(context, listen: false).manageDialog();
    });
  }

  /// Load all data for the homepage
  Future<void> _loadData(bool reload) async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final flashDealProvider = Provider.of<FlashDealProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final wishListProvider = Provider.of<WishListProvider>(context, listen: false);

    ConfigModel? config = Provider.of<SplashProvider>(context, listen: false).configModel;

    if (reload) {
      Provider.of<SplashProvider>(context, listen: false).initConfig(source: DataSourceEnum.client);
      Provider.of<SplashProvider>(context, listen: false).getDeliveryInfo();
    }

    // Load categories
    Provider.of<CategoryProvider>(context, listen: false).getCategoryList(context, reload);

    // Load banners
    Provider.of<BannerProvider>(context, listen: false).getBannerList(context, reload);

    // Load daily products
    if (productProvider.dailyProductModel == null || reload) {
      productProvider.getItemList(1, isUpdate: false, productType: ProductType.dailyItem);
    }

    // Load featured products
    if (productProvider.featuredProductModel == null || reload) {
      productProvider.getItemList(1, isUpdate: false, productType: ProductType.featuredItem);
    }

    // Load most viewed products
    if (productProvider.mostViewedProductModel == null || reload) {
      productProvider.getItemList(1, isUpdate: false, productType: ProductType.mostReviewed);
    }

    // Load all products
    productProvider.getAllProductList(1, reload, isUpdate: false);

    // Load wishlist if logged in
    if (authProvider.isLoggedIn()) {
      wishListProvider.getWishListProduct();
    }

    // Load flash deals
    if ((config?.flashDealProductStatus ?? false) && (flashDealProvider.flashDealModel == null || reload)) {
      flashDealProvider.getFlashDealProducts(1, isUpdate: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebHeaderWidget(),
      drawer: const WebCategoryDrawer(),
      endDrawer: const WebSidebarMenu(),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.webDarkBackground
          : AppColors.webLightBackground,
      bottomNavigationBar: const MobileBottomNavBar(currentIndex: 0),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadData(true);
          Provider.of<OrderProvider>(Get.context!, listen: false).manageDialog();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // Hero Banner Carousel
              Consumer<BannerProvider>(
                builder: (context, bannerProvider, child) {
                  return (bannerProvider.bannerList?.isEmpty ?? true)
                      ? const SizedBox()
                      : const WebBannerWidget();
                },
              ),

              // Main Content with responsive max width
              Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: ResponsiveDimensions.getMaxContentWidth(context)),
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveDimensions.getHorizontalPadding(context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ResponsiveDimensions.padding(context, 32)),

                      // Best-Selling Categories Section
                      const WebCategoryCirclesWidget(),

                      SizedBox(height: ResponsiveDimensions.padding(context, 40)),

                      // Promotions Section (Featured/Flash Deal Products)
                      Selector<SplashProvider, ConfigModel?>(
                        selector: (ctx, splashProvider) => splashProvider.configModel,
                        builder: (context, configModel, _) {
                          return (configModel?.flashDealProductStatus ?? false)
                              ? Consumer<FlashDealProvider>(
                                  builder: (context, flashDealProvider, _) {
                                    return flashDealProvider.flashDealModel?.products != null &&
                                            flashDealProvider.flashDealModel!.products!.isNotEmpty
                                        ? WebProductSectionWidget(
                                            title: 'Promotions',
                                            products: flashDealProvider.flashDealModel!.products!,
                                            productType: ProductType.flashSale,
                                            showViewAll: true,
                                            onViewAll: () {
                                              Navigator.of(context).pushNamed(
                                                RouteHelper.getHomeItemRoute(ProductType.flashSale),
                                              );
                                            },
                                          )
                                        : const SizedBox();
                                  },
                                )
                              : const SizedBox();
                        },
                      ),

                      SizedBox(height: ResponsiveDimensions.padding(context, 40)),

                      // Care Essentials Section (Daily Needs)
                      Consumer<ProductProvider>(
                        builder: (context, productProvider, _) {
                          return (productProvider.dailyProductModel?.products?.isNotEmpty ?? false)
                              ? WebProductSectionWidget(
                                  title: 'Care Essentials',
                                  products: productProvider.dailyProductModel!.products!,
                                  productType: ProductType.dailyItem,
                                  showViewAll: true,
                                  onViewAll: () {
                                    Navigator.of(context).pushNamed(
                                      RouteHelper.getHomeItemRoute(ProductType.dailyItem),
                                    );
                                  },
                                )
                              : const SizedBox();
                        },
                      ),

                      SizedBox(height: ResponsiveDimensions.padding(context, 40)),

                      // Featured Products Section
                      Selector<SplashProvider, ConfigModel?>(
                        selector: (ctx, splashProvider) => splashProvider.configModel,
                        builder: (context, configModel, _) {
                          return (configModel?.featuredProductStatus ?? false)
                              ? Consumer<ProductProvider>(
                                  builder: (context, productProvider, _) {
                                    return (productProvider.featuredProductModel?.products?.isNotEmpty ?? false)
                                        ? WebProductSectionWidget(
                                            title: 'Featured Products',
                                            products: productProvider.featuredProductModel!.products!,
                                            productType: ProductType.featuredItem,
                                            showViewAll: true,
                                            onViewAll: () {
                                              Navigator.of(context).pushNamed(
                                                RouteHelper.getHomeItemRoute(ProductType.featuredItem),
                                              );
                                            },
                                          )
                                        : const SizedBox();
                                  },
                                )
                              : const SizedBox();
                        },
                      ),

                      SizedBox(height: ResponsiveDimensions.padding(context, 40)),

                      // Most Reviewed Section
                      Selector<SplashProvider, ConfigModel?>(
                        selector: (ctx, splashProvider) => splashProvider.configModel,
                        builder: (context, configModel, _) {
                          return (configModel?.mostReviewedProductStatus ?? false)
                              ? Consumer<ProductProvider>(
                                  builder: (context, productProvider, _) {
                                    return (productProvider.mostViewedProductModel?.products?.isNotEmpty ?? false)
                                        ? WebProductSectionWidget(
                                            title: 'Most Reviewed',
                                            products: productProvider.mostViewedProductModel!.products!,
                                            productType: ProductType.mostReviewed,
                                            showViewAll: true,
                                            onViewAll: () {
                                              Navigator.of(context).pushNamed(
                                                RouteHelper.getHomeItemRoute(ProductType.mostReviewed),
                                              );
                                            },
                                          )
                                        : const SizedBox();
                                  },
                                )
                              : const SizedBox();
                        },
                      ),

                      SizedBox(height: ResponsiveDimensions.padding(context, 40)),

                      // All Products Section
                      Consumer<ProductProvider>(
                        builder: (context, productProvider, _) {
                          return (productProvider.allProductModel?.products?.isNotEmpty ?? false)
                              ? WebProductSectionWidget(
                                  title: 'All Products',
                                  products: productProvider.allProductModel!.products!.take(12).toList(),
                                  productType: 'all',
                                  showViewAll: true,
                                  onViewAll: () {
                                    Navigator.of(context).pushNamed(RouteHelper.categories);
                                  },
                                )
                              : const SizedBox();
                        },
                      ),

                      SizedBox(height: ResponsiveDimensions.padding(context, 48)),
                    ],
                  ),
                ),
              ),

              // Footer
              const FooterWebWidget(footerType: FooterType.nonSliver),
            ],
          ),
        ),
      ),
    );
  }

  // Old footer method - kept for reference if needed
  // ignore: unused_element
  Widget _buildOldFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '© 2024 Your Store. All rights reserved.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('About Us'),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {},
                child: const Text('Contact'),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {},
                child: const Text('Privacy Policy'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
