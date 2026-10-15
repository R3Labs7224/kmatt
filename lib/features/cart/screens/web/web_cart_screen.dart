import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/no_data_widget.dart';
import 'package:flutter_grocery/common/widgets/web/mobile_bottom_nav_bar.dart';
import 'package:flutter_grocery/common/widgets/web/web_category_drawer.dart';
import 'package:flutter_grocery/common/widgets/web/web_header_widget.dart';
import 'package:flutter_grocery/common/widgets/web/web_sidebar_menu.dart';
import 'package:flutter_grocery/features/cart/widgets/cart_button_widget.dart';
import 'package:flutter_grocery/features/cart/widgets/cart_details_widget.dart';
import 'package:flutter_grocery/features/cart/widgets/cart_product_list_widget.dart';
import 'package:flutter_grocery/features/coupon/providers/coupon_provider.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/cart_helper.dart';
import 'package:flutter_grocery/helper/responsive_dimensions.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/theme/app_colors.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:provider/provider.dart';

/// Web-specific cart screen with modern header
class WebCartScreen extends StatefulWidget {
  const WebCartScreen({super.key});

  @override
  State<WebCartScreen> createState() => _WebCartScreenState();
}

class _WebCartScreenState extends State<WebCartScreen> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _couponController.clear();
    Provider.of<CouponProvider>(context, listen: false).removeCouponData(false);
    Provider.of<OrderProvider>(context, listen: false).setOrderType('delivery', notify: false);
  }

  @override
  Widget build(BuildContext context) {
    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;
    final CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: const WebHeaderWidget(),
      drawer: const WebCategoryDrawer(),
      endDrawer: const WebSidebarMenu(),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.webDarkBackground
          : const Color(0xFFF8F9FA),
      bottomNavigationBar: const MobileBottomNavBar(currentIndex: 2),
      body: Consumer<CouponProvider>(
        builder: (context, couponProvider, _) {
          return Consumer<CartProvider>(
            builder: (context, cart, child) {
              double itemPrice = 0;
              double discount = 0;
              double tax = 0;

              for (var cartModel in cart.cartList) {
                itemPrice = itemPrice + (cartModel.price! * cartModel.quantity!);
                discount = discount + (cartModel.discount! * cartModel.quantity!);
                tax = tax + (cartModel.tax! * cartModel.quantity!);
              }

              double subTotal = itemPrice + (configModel.isVatTexInclude! ? 0 : tax);
              bool isFreeDelivery = subTotal >= configModel.freeDeliveryOverAmount! &&
                      configModel.freeDeliveryStatus! ||
                  couponProvider.coupon?.couponType == 'free_delivery';

              double total = subTotal - discount - Provider.of<CouponProvider>(context).discount!;

              double weight = 0.0;
              weight = isFreeDelivery ? 0 : CartHelper.weightCalculation(cartProvider.cartList);

              return cart.cartList.isNotEmpty
                  ? CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final useMobileLayout = ResponsiveDimensions.shouldUseMobileLayout(context);

                              return Center(
                                child: Container(
                                  constraints: BoxConstraints(maxWidth: ResponsiveDimensions.getMaxContentWidth(context)),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveDimensions.getHorizontalPadding(context),
                                    vertical: ResponsiveDimensions.padding(context, Dimensions.paddingSizeLarge),
                                  ),
                                  child: useMobileLayout
                                      ? _buildMobileLayout(
                                          context,
                                          cart,
                                          total,
                                          isFreeDelivery,
                                          itemPrice,
                                          tax,
                                          discount,
                                          subTotal,
                                          configModel,
                                          weight,
                                        )
                                      : _buildDesktopLayout(
                                          context,
                                          cart,
                                          total,
                                          isFreeDelivery,
                                          itemPrice,
                                          tax,
                                          discount,
                                          subTotal,
                                          configModel,
                                          weight,
                                        ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Footer
                        const FooterWebWidget(footerType: FooterType.sliver),
                      ],
                    )
                  : Center(
                      child: NoDataWidget(
                        image: Images.favouriteNoDataImage,
                        title: getTranslated('empty_shopping_bag', context),
                      ),
                    );
            },
          );
        },
      ),
    );
  }

  // Mobile layout: Cart items on top, summary below
  Widget _buildMobileLayout(
    BuildContext context,
    CartProvider cart,
    double total,
    bool isFreeDelivery,
    double itemPrice,
    double tax,
    double discount,
    double subTotal,
    dynamic configModel,
    double weight,
  ) {
    return Column(
      children: [
        // Cart items
        Container(
          padding: EdgeInsets.all(ResponsiveDimensions.padding(context, Dimensions.paddingSizeLarge)),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.webDarkCard
                : Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, Dimensions.radiusSizeDefault)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: ResponsiveDimensions.scale(context, 1),
                blurRadius: ResponsiveDimensions.scale(context, 4),
              ),
            ],
          ),
          child: const CartProductListWidget(),
        ),

        SizedBox(height: ResponsiveDimensions.padding(context, Dimensions.paddingSizeLarge)),

        // Cart summary
        CartDetailsWidget(
          couponController: _couponController,
          total: total,
          isFreeDelivery: isFreeDelivery,
          itemPrice: itemPrice,
          tax: tax,
          discount: discount,
        ),

        SizedBox(height: ResponsiveDimensions.padding(context, Dimensions.paddingSizeLarge)),

        // Checkout button
        CartButtonWidget(
          subTotal: subTotal,
          configModel: configModel,
          itemPrice: itemPrice,
          total: total,
          isFreeDelivery: isFreeDelivery,
          discount: discount,
          tax: tax,
          weight: weight,
        ),
      ],
    );
  }

  // Desktop layout: Cart items on left, summary on right
  Widget _buildDesktopLayout(
    BuildContext context,
    CartProvider cart,
    double total,
    bool isFreeDelivery,
    double itemPrice,
    double tax,
    double discount,
    double subTotal,
    dynamic configModel,
    double weight,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Cart items
        Expanded(
          flex: 6,
          child: Container(
            padding: EdgeInsets.only(
              left: ResponsiveDimensions.padding(context, Dimensions.paddingSizeLarge),
              right: ResponsiveDimensions.padding(context, Dimensions.paddingSizeLarge),
              top: ResponsiveDimensions.padding(context, Dimensions.paddingSizeLarge),
              bottom: ResponsiveDimensions.padding(context, Dimensions.paddingSizeSmall),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.webDarkCard
                  : Colors.white,
              borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, Dimensions.radiusSizeDefault)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  spreadRadius: ResponsiveDimensions.scale(context, 1),
                  blurRadius: ResponsiveDimensions.scale(context, 4),
                ),
              ],
            ),
            child: const CartProductListWidget(),
          ),
        ),

        SizedBox(width: ResponsiveDimensions.padding(context, Dimensions.paddingSizeLarge)),

        // Right side - Cart details and checkout
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CartDetailsWidget(
                couponController: _couponController,
                total: total,
                isFreeDelivery: isFreeDelivery,
                itemPrice: itemPrice,
                tax: tax,
                discount: discount,
              ),
              SizedBox(height: ResponsiveDimensions.padding(context, Dimensions.paddingSizeLarge)),
              CartButtonWidget(
                subTotal: subTotal,
                configModel: configModel,
                itemPrice: itemPrice,
                total: total,
                isFreeDelivery: isFreeDelivery,
                discount: discount,
                tax: tax,
                weight: weight,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }
}
