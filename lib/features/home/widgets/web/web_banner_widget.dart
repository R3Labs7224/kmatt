import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/features/category/domain/models/category_model.dart';
import 'package:flutter_grocery/features/category/providers/category_provider.dart';
import 'package:flutter_grocery/features/home/providers/banner_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/responsive_dimensions.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/theme/app_colors.dart';
import 'package:provider/provider.dart';

/// Modern centered banner carousel - Fully responsive
class WebBannerWidget extends StatefulWidget {
  const WebBannerWidget({super.key});

  @override
  State<WebBannerWidget> createState() => _WebBannerWidgetState();
}

class _WebBannerWidgetState extends State<WebBannerWidget> {
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Consumer<BannerProvider>(
      builder: (context, bannerProvider, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsive banner sizing
                final maxContentWidth = ResponsiveDimensions.getMaxContentWidth(context);
                double bannerWidth = constraints.maxWidth * 0.968;
                if (bannerWidth > maxContentWidth) {
                  bannerWidth = maxContentWidth;
                }

                // Responsive height based on screen size
                // Mobile: reduce by 20% (360 * 0.8 = 288)
                final useMobileLayout = ResponsiveDimensions.shouldUseMobileLayout(context);
                final baseHeight = useMobileLayout ? 288.0 : 360.0;
                final bannerHeight = ResponsiveDimensions.height(context, baseHeight).clamp(200.0, 360.0);
                final borderRadius = ResponsiveDimensions.scale(context, 12);

                return Container(
                  width: bannerWidth,
                  height: bannerHeight,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CarouselSlider.builder(
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          height: bannerHeight,
                          viewportFraction: 1.0,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          autoPlayAnimationDuration: const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.easeInOut,
                          enlargeCenterPage: false,
                          scrollDirection: Axis.horizontal,
                          pageSnapping: true,
                          onPageChanged: (index, reason) {
                            Provider.of<BannerProvider>(context, listen: false).setCurrentIndex(index);
                          },
                        ),
                        itemCount: bannerProvider.bannerList!.length,
                        itemBuilder: (context, index, _) {
                          return _BannerItem(
                            banner: bannerProvider.bannerList![index],
                            index: index,
                            currentIndex: bannerProvider.currentIndex,
                            bannerHeight: bannerHeight,
                            borderRadius: borderRadius,
                            onTap: () => _handleBannerTap(context, bannerProvider, index),
                          );
                        },
                      ),

                      Positioned(
                        bottom: ResponsiveDimensions.padding(context, 20),
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: bannerProvider.bannerList!.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => _carouselController.jumpToPage(entry.key),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 10,
                                height: 10,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: bannerProvider.currentIndex == entry.key
                                      ? AppColors.webPrimaryBlue
                                      : Colors.white.withValues(alpha: 0.6),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _handleBannerTap(BuildContext context, BannerProvider bannerProvider, int index) {
    if (bannerProvider.bannerList![index].productId != null) {
      // Navigate to product details
      Product? product;
      for (Product prod in bannerProvider.productList) {
        if (prod.id == bannerProvider.bannerList![index].productId) {
          product = prod;
          break;
        }
      }
      if (product != null) {
        Navigator.pushNamed(
          context,
          RouteHelper.getProductDetailsRoute(productId: product.id),
        );
      }
    } else if (bannerProvider.bannerList![index].categoryId != null) {
      // Navigate to category products
      CategoryModel? category;
      for (CategoryModel categoryModel in Provider.of<CategoryProvider>(context, listen: false).categoryList!) {
        if (categoryModel.id == bannerProvider.bannerList![index].categoryId) {
          category = categoryModel;
          break;
        }
      }
      if (category != null) {
        Navigator.of(context).pushNamed(
          RouteHelper.getCategoryProductsRoute(categoryId: '${category.id}'),
        );
      }
    }
  }
}

/// Individual banner item with zoom-out animation
class _BannerItem extends StatefulWidget {
  final dynamic banner;
  final int index;
  final int currentIndex;
  final double bannerHeight;
  final double borderRadius;
  final VoidCallback onTap;

  const _BannerItem({
    required this.banner,
    required this.index,
    required this.currentIndex,
    required this.bannerHeight,
    required this.borderRadius,
    required this.onTap,
  });

  @override
  State<_BannerItem> createState() => _BannerItemState();
}

class _BannerItemState extends State<_BannerItem> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.1,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(_BannerItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger animation when this banner becomes active
    if (widget.currentIndex == widget.index && oldWidget.currentIndex != widget.index) {
      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Start animation if this is the current slide
    if (widget.currentIndex == widget.index && !_animationController.isAnimating) {
      _animationController.forward(from: 0);
    }

    return InkWell(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return AnimatedOpacity(
            opacity: widget.currentIndex == widget.index ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 600),
            child: Transform.scale(
              scale: widget.currentIndex == widget.index ? _scaleAnimation.value : 1.0,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  color: Colors.white,
                ),
                clipBehavior: Clip.antiAlias,
                child: CustomImageWidget(
                  image: Provider.of<SplashProvider>(context, listen: false).baseUrls != null
                      ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}/${widget.banner.image}'
                      : '',
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: widget.bannerHeight,
                  useIconPlaceholder: true,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
