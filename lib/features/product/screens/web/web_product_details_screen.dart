import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/cart_model.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/common/providers/product_provider.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/web/mobile_bottom_nav_bar.dart';
import 'package:flutter_grocery/common/widgets/web/web_category_drawer.dart';
import 'package:flutter_grocery/common/widgets/web/web_header_widget.dart';
import 'package:flutter_grocery/common/widgets/web/web_product_card.dart';
import 'package:flutter_grocery/common/widgets/web/web_sidebar_menu.dart';
import 'package:flutter_grocery/features/product/widgets/product_review_widget.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/cart_helper.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_dimensions.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/theme/app_colors.dart';
import 'package:flutter_grocery/utill/product_type.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

/// Modern web-specific product details page
class WebProductDetailsScreen extends StatefulWidget {
  final String? productId;
  final bool? fromSearch;

  const WebProductDetailsScreen({
    super.key,
    required this.productId,
    this.fromSearch = false,
  });

  @override
  State<WebProductDetailsScreen> createState() => _WebProductDetailsScreenState();
}

class _WebProductDetailsScreenState extends State<WebProductDetailsScreen> {
  final ScrollController scrollController = ScrollController();
  final ScrollController featuredScrollController = ScrollController();
  final int _selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    final ProductProvider productProvider = Provider.of(context, listen: false);
    productProvider.getProductDetails('${widget.productId}', searchQuery: widget.fromSearch!);
    Provider.of<CartProvider>(context, listen: false).getCartData();
    Provider.of<CartProvider>(context, listen: false).onSelectProductStatus(0, false);
    productProvider.getProductReviews(id: widget.productId, offset: 1, isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Scaffold(
      appBar: const WebHeaderWidget(),
      drawer: const WebCategoryDrawer(),
      endDrawer: const WebSidebarMenu(),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.webDarkBackground
          : AppColors.webLightBackground,
      bottomNavigationBar: const MobileBottomNavBar(currentIndex: 0),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              if (productProvider.product == null) {
                return Center(
                  child: CustomLoaderWidget(color: Theme.of(context).primaryColor),
                );
              }

              final product = productProvider.product!;
              CartModel? cartModel = CartHelper.getCartModel(
                product,
                quantity: cartProvider.quantity,
                variationIndexList: cartProvider.variationIndex,
              );

              cartProvider.setExistData(cartProvider.isExistInCart(cartModel));

              double? priceWithDiscount = PriceConverterHelper.convertWithDiscount(
                cartModel?.price,
                product.discount,
                product.discountType,
              );

              return SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    // Main Content
                    Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: ResponsiveDimensions.getMaxContentWidth(context)),
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveDimensions.getHorizontalPadding(context),
                          vertical: ResponsiveDimensions.padding(context, 40),
                        ),
                        child: Column(
                          children: [
                            // Product Section - Responsive Layout
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final useMobileLayout = ResponsiveDimensions.shouldUseMobileLayout(context);

                                if (useMobileLayout) {
                                  // Mobile: Image on top, details below
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Product Image - Centered with intrinsic width
                                      Center(
                                        child: Container(
                                          height: ResponsiveDimensions.height(context, 350),
                                          constraints: BoxConstraints(
                                            maxWidth: ResponsiveDimensions.width(context, 350),
                                          ),
                                          padding: EdgeInsets.all(ResponsiveDimensions.padding(context, 8)),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, 12)),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: ResponsiveDimensions.scale(context, 2),
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, 8)),
                                            child: CustomImageWidget(
                                              image: splashProvider.baseUrls != null &&
                                                      product.image != null &&
                                                      product.image!.isNotEmpty
                                                  ? '${splashProvider.baseUrls!.productImageUrl}/${product.image![_selectedImageIndex]}'
                                                  : '',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: ResponsiveDimensions.padding(context, 20)),

                                      // Product Details
                                      _buildProductDetails(context, product, cartModel, cartProvider, priceWithDiscount!),
                                    ],
                                  );
                                }

                                // Desktop: Side by side layout
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Left Side - Images (40% width)
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: ResponsiveDimensions.height(context, 400),
                                            width: ResponsiveDimensions.width(context, 285),
                                            padding: EdgeInsets.all(ResponsiveDimensions.padding(context, 4)),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, 12)),
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                                width: ResponsiveDimensions.scale(context, 2),
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, 8)),
                                              child: CustomImageWidget(
                                                image: splashProvider.baseUrls != null &&
                                                        product.image != null &&
                                                        product.image!.isNotEmpty
                                                    ? '${splashProvider.baseUrls!.productImageUrl}/${product.image![_selectedImageIndex]}'
                                                    : '',
                                                fit: BoxFit.contain,
                                                height: ResponsiveDimensions.height(context, 642),
                                                width: ResponsiveDimensions.width(context, 577),
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: ResponsiveDimensions.padding(context, 16)),

                                          // Small current image thumbnail below
                                          Container(
                                            width: ResponsiveDimensions.scale(context, 80),
                                            height: ResponsiveDimensions.scale(context, 80),
                                            padding: EdgeInsets.all(ResponsiveDimensions.padding(context, 2)),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, 8)),
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                                width: ResponsiveDimensions.scale(context, 2),
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, 6)),
                                              child: CustomImageWidget(
                                                image: splashProvider.baseUrls != null &&
                                                        product.image != null &&
                                                        product.image!.isNotEmpty
                                                    ? '${splashProvider.baseUrls!.productImageUrl}/${product.image![_selectedImageIndex]}'
                                                    : '',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(width: ResponsiveDimensions.padding(context, 40)),

                                    // Right Side - Product Details (60% width)
                                    Expanded(
                                      flex: 6,
                                      child: _buildProductDetails(context, product, cartModel, cartProvider, priceWithDiscount!),
                                    ),
                                  ],
                                );
                              },
                            ),

                            SizedBox(height: ResponsiveDimensions.padding(context, 48)),

                            // Description Section
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Description',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: ResponsiveDimensions.fontSize(context, 20),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveDimensions.padding(context, 16)),
                                  Text(
                                    product.description ?? '',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: ResponsiveDimensions.fontSize(context, 14),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins',
                                      color: Colors.grey.shade700,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: ResponsiveDimensions.padding(context, 48)),

                            // Top Featured Products Section
                            Consumer<ProductProvider>(
                              builder: (context, productProv, _) {
                                final featuredProducts = productProv.featuredProductModel?.products ?? [];

                                if (featuredProducts.isEmpty) {
                                  return const SizedBox.shrink();
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title with Navigation Arrows
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Featured Products',
                                          style: TextStyle(
                                            fontSize: ResponsiveDimensions.fontSize(context, 18),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Poppins',
                                            color: Colors.black,
                                          ),
                                        ),
                                        if (featuredProducts.length > 5)
                                          Row(
                                            children: [
                                              // Left Arrow Button
                                              Container(
                                                width: ResponsiveDimensions.scale(context, 40),
                                                height: ResponsiveDimensions.scale(context, 40),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.arrow_back,
                                                    size: ResponsiveDimensions.scale(context, 20),
                                                  ),
                                                  onPressed: () {
                                                    featuredScrollController.animateTo(
                                                      featuredScrollController.offset - 300,
                                                      duration: const Duration(milliseconds: 300),
                                                      curve: Curves.easeInOut,
                                                    );
                                                  },
                                                  padding: EdgeInsets.zero,
                                                ),
                                              ),
                                              SizedBox(width: ResponsiveDimensions.padding(context, 8)),
                                              // Right Arrow Button
                                              Container(
                                                width: ResponsiveDimensions.scale(context, 40),
                                                height: ResponsiveDimensions.scale(context, 40),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.arrow_forward,
                                                    size: ResponsiveDimensions.scale(context, 20),
                                                  ),
                                                  onPressed: () {
                                                    featuredScrollController.animateTo(
                                                      featuredScrollController.offset + 300,
                                                      duration: const Duration(milliseconds: 300),
                                                      curve: Curves.easeInOut,
                                                    );
                                                  },
                                                  padding: EdgeInsets.zero,
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: ResponsiveDimensions.padding(context, 24)),
                                    // Products List
                                    SizedBox(
                                      height: ResponsiveDimensions.height(context, 380),
                                      child: ListView.builder(
                                        controller: featuredScrollController,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: featuredProducts.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            width: ResponsiveDimensions.width(context, 220),
                                            margin: EdgeInsets.only(
                                              right: ResponsiveDimensions.padding(context, 16),
                                            ),
                                            child: WebProductCard(
                                              product: featuredProducts[index],
                                              productType: ProductType.featuredItem,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),

                            SizedBox(height: ResponsiveDimensions.padding(context, 48)),

                            // Reviews Section
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Customer Reviews',
                                  style: TextStyle(
                                    fontSize: ResponsiveDimensions.fontSize(context, 28),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(height: ResponsiveDimensions.padding(context, 8)),
                                Text(
                                  'Share Your Thoughts With Other Customers',
                                  style: TextStyle(
                                    fontSize: ResponsiveDimensions.fontSize(context, 16),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins',
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: ResponsiveDimensions.padding(context, 32)),

                                // Divider line
                                Container(
                                  height: ResponsiveDimensions.scale(context, 1),
                                  color: Colors.grey.shade300,
                                ),

                                SizedBox(height: ResponsiveDimensions.padding(context, 40)),

                                // Show reviews or no reviews message
                                if (productProvider.productReviews?.reviewList != null &&
                                    productProvider.productReviews!.reviewList!.isNotEmpty)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: productProvider.productReviews!.reviewList!.length,
                                    itemBuilder: (context, index) {
                                      return ProductReviewWidget(
                                        review: productProvider.productReviews!.reviewList![index],
                                      );
                                    },
                                  )
                                else
                                  // No reviews layout
                                  Center(
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/svg/no-reviews.svg',
                                          width: ResponsiveDimensions.width(context, 400),
                                          height: ResponsiveDimensions.height(context, 300),
                                        ),
                                        SizedBox(height: ResponsiveDimensions.padding(context, 24)),
                                        Text(
                                          'Be The First One To Write A Review!',
                                          style: TextStyle(
                                            fontSize: ResponsiveDimensions.fontSize(context, 18),
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: ResponsiveDimensions.padding(context, 40)),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Footer
                    const FooterWebWidget(footerType: FooterType.nonSliver),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Build product details section (reusable for both mobile and desktop)
  Widget _buildProductDetails(
    BuildContext context,
    dynamic product,
    CartModel? cartModel,
    CartProvider cartProvider,
    double priceWithDiscount,
  ) {
    final useMobileLayout = ResponsiveDimensions.shouldUseMobileLayout(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name
        Text(
          product.name ?? '',
          style: TextStyle(
            fontSize: ResponsiveDimensions.fontSize(context, useMobileLayout ? 20 : 18),
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
            height: 1.3,
          ),
        ),

        SizedBox(height: ResponsiveDimensions.padding(context, 12)),

        // Rating
        Row(
          children: [
            Icon(
              Icons.star,
              color: Colors.amber.shade600,
              size: ResponsiveDimensions.scale(context, 18),
            ),
            SizedBox(width: ResponsiveDimensions.padding(context, 4)),
            Text(
              product.rating != null && product.rating!.isNotEmpty
                  ? (product.rating![0].average?.toStringAsFixed(1) ?? '0.00')
                  : '0.00',
              style: TextStyle(
                fontSize: ResponsiveDimensions.fontSize(context, 14),
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),

        SizedBox(height: ResponsiveDimensions.padding(context, 20)),

        // Grey divider above price
        Divider(
          color: Colors.grey.shade300,
          thickness: ResponsiveDimensions.scale(context, 1),
        ),

        SizedBox(height: ResponsiveDimensions.padding(context, 16)),

        // Price Section
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Current Price
            CustomDirectionalityWidget(
              child: Text(
                PriceConverterHelper.convertPrice(context, priceWithDiscount),
                style: TextStyle(
                  fontSize: ResponsiveDimensions.fontSize(context, useMobileLayout ? 28 : 24),
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
            ),

            SizedBox(width: ResponsiveDimensions.padding(context, 12)),

            // Original Price (if discounted)
            if (product.price! > priceWithDiscount)
              CustomDirectionalityWidget(
                child: Text(
                  PriceConverterHelper.convertPrice(context, product.price),
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.fontSize(context, useMobileLayout ? 18 : 16),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: Colors.grey.shade500,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ),

            SizedBox(width: ResponsiveDimensions.padding(context, 8)),

            // Discount Badge
            if (product.discount != null && product.discount! > 0)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveDimensions.padding(context, 8),
                  vertical: ResponsiveDimensions.padding(context, 4),
                ),
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, 4)),
                ),
                child: Text(
                  product.discountType == 'percent'
                      ? '(${product.discount?.toStringAsFixed(2)}% Off)'
                      : 'SALE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveDimensions.fontSize(context, 12),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
          ],
        ),

        SizedBox(height: ResponsiveDimensions.padding(context, 24)),

        // Add to Cart Button or Quantity Counter - 30% bigger on mobile
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: ResponsiveDimensions.height(context, useMobileLayout ? 47 : 36), // 36 * 1.3 ≈ 47
            child: cartProvider.isExistInCart(cartModel) != null
                ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveDimensions.padding(context, useMobileLayout ? 10 : 8),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, useMobileLayout ? 26 : 20)),
                      border: Border.all(
                        color: AppColors.webPrimaryBlue,
                        width: ResponsiveDimensions.scale(context, useMobileLayout ? 2 : 1.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            final cardIndex = cartProvider.isExistInCart(cartModel);
                            if (cardIndex != null) {
                              if (cartProvider.cartList[cardIndex].quantity! > 1) {
                                cartProvider.setCartQuantity(
                                  false,
                                  cardIndex,
                                  context: context,
                                  showMessage: true,
                                );
                              } else {
                                cartProvider.removeItemFromCart(cardIndex, context);
                              }
                            }
                          },
                          child: Icon(
                            Icons.remove,
                            size: ResponsiveDimensions.scale(context, useMobileLayout ? 23 : 18), // 18 * 1.3 ≈ 23
                            color: AppColors.webPrimaryBlue,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveDimensions.padding(context, useMobileLayout ? 16 : 12),
                          ),
                          child: Text(
                            cartProvider.isExistInCart(cartModel) != null
                                ? cartProvider.cartList[cartProvider.isExistInCart(cartModel)!].quantity.toString()
                                : '0',
                            style: TextStyle(
                              fontSize: ResponsiveDimensions.fontSize(context, useMobileLayout ? 18 : 14), // 14 * 1.3 ≈ 18
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: AppColors.webPrimaryBlue,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            final cardIndex = cartProvider.isExistInCart(cartModel);
                            if (cardIndex != null) {
                              if (product.maximumOrderQuantity == null ||
                                  cartProvider.cartList[cardIndex].quantity! <
                                      product.maximumOrderQuantity!) {
                                if (cartProvider.cartList[cardIndex].quantity! <
                                    (cartProvider.cartList[cardIndex].stock ?? 0)) {
                                  cartProvider.setCartQuantity(
                                    true,
                                    cardIndex,
                                    showMessage: true,
                                    context: context,
                                  );
                                } else {
                                  showCustomSnackBarHelper(
                                    getTranslated('out_of_stock', context),
                                  );
                                }
                              } else {
                                showCustomSnackBarHelper(
                                  '${getTranslated('you_can_add_max', context)} ${product.maximumOrderQuantity} ${getTranslated('items', context)} ${getTranslated('only', context)}',
                                );
                              }
                            }
                          },
                          child: Icon(
                            Icons.add,
                            size: ResponsiveDimensions.scale(context, useMobileLayout ? 23 : 18), // 18 * 1.3 ≈ 23
                            color: AppColors.webPrimaryBlue,
                          ),
                        ),
                      ],
                    ),
                  )
                : ElevatedButton(
                    onPressed: (cartModel?.stock ?? 0) > 0
                        ? () {
                            if (product.variations == null ||
                                product.variations!.isEmpty) {
                              if ((cartModel?.stock ?? 0) > 0) {
                                cartProvider.addToCart(cartModel!);
                                showCustomSnackBarHelper(
                                  getTranslated('added_to_cart', context),
                                  isError: false,
                                );
                              } else {
                                showCustomSnackBarHelper(
                                  getTranslated('out_of_stock', context),
                                );
                              }
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.webPrimaryBlue,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      disabledForegroundColor: Colors.grey.shade600,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveDimensions.padding(context, useMobileLayout ? 31 : 24), // 24 * 1.3 ≈ 31
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, useMobileLayout ? 26 : 20)),
                      ),
                    ),
                    child: Text(
                      (cartModel?.stock ?? 0) <= 0
                          ? getTranslated('out_of_stock', context)
                          : 'ADD',
                      style: TextStyle(
                        fontSize: ResponsiveDimensions.fontSize(context, useMobileLayout ? 17 : 13), // 13 * 1.3 ≈ 17
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    featuredScrollController.dispose();
    super.dispose();
  }
}
