import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/cart_model.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_dimensions.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import 'package:flutter_grocery/theme/app_colors.dart';
import 'package:flutter_grocery/utill/product_type.dart';
import 'package:provider/provider.dart';

/// Web-specific product card with clean, modern design
class WebProductCard extends StatefulWidget {
  final Product product;
  final String productType;

  const WebProductCard({
    super.key,
    required this.product,
    required this.productType,
  });

  @override
  State<WebProductCard> createState() => _WebProductCardState();
}

class _WebProductCardState extends State<WebProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    double? priceWithDiscount = 0;
    double? categoryDiscountAmount;

    if (widget.product.categoryDiscount != null) {
      categoryDiscountAmount = PriceConverterHelper.convertWithDiscount(
        widget.product.price,
        widget.product.categoryDiscount?.discountAmount,
        widget.product.categoryDiscount?.discountType,
        maxDiscount: widget.product.categoryDiscount?.maximumAmount,
      );
    }

    priceWithDiscount = PriceConverterHelper.convertWithDiscount(
      widget.product.price,
      widget.product.discount,
      widget.product.discountType,
    );

    if (categoryDiscountAmount != null &&
        categoryDiscountAmount > 0 &&
        categoryDiscountAmount < priceWithDiscount!) {
      priceWithDiscount = categoryDiscountAmount;
    }

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        double price = 0;
        int? stock = 0;
        bool isExistInCart = false;
        int? cardIndex;
        CartModel? cartModel;

        if (widget.product.variations!.isNotEmpty) {
          for (int index = 0; index < widget.product.variations!.length; index++) {
            price = widget.product.variations!.isNotEmpty
                ? (widget.product.variations![index].price ?? 0)
                : (widget.product.price ?? 0);
            stock = widget.product.variations!.isNotEmpty
                ? widget.product.variations![index].stock
                : widget.product.totalStock;
            cartModel = CartModel(
              widget.product.id,
              widget.product.image!.isNotEmpty ? widget.product.image![0] : '',
              widget.product.name,
              price,
              PriceConverterHelper.convertWithDiscount(
                  price, widget.product.discount, widget.product.discountType),
              1,
              widget.product.variations!.isNotEmpty
                  ? widget.product.variations![index]
                  : null,
              (price -
                  PriceConverterHelper.convertWithDiscount(price,
                      widget.product.discount, widget.product.discountType)!),
              (price -
                  PriceConverterHelper.convertWithDiscount(
                      price, widget.product.tax, widget.product.taxType)!),
              widget.product.capacity,
              widget.product.unit,
              stock,
              widget.product,
            );
            isExistInCart = cartProvider.isExistInCart(cartModel) != null;
            cardIndex = cartProvider.isExistInCart(cartModel);

            if (isExistInCart) {
              break;
            }
          }
        } else {
          price = widget.product.price ?? 0;
          stock = widget.product.totalStock;
          cartModel = CartModel(
            widget.product.id,
            (widget.product.image?.isNotEmpty ?? false)
                ? widget.product.image![0]
                : '',
            widget.product.name,
            price,
            PriceConverterHelper.convertWithDiscount(
                price, widget.product.discount, widget.product.discountType),
            1,
            null,
            (price -
                PriceConverterHelper.convertWithDiscount(
                    price, widget.product.discount, widget.product.discountType)!),
            (price -
                PriceConverterHelper.convertWithDiscount(
                    price, widget.product.tax, widget.product.taxType)!),
            widget.product.capacity,
            widget.product.unit,
            stock,
            widget.product,
          );

          isExistInCart = cartProvider.isExistInCart(cartModel) != null;
          cardIndex = cartProvider.isExistInCart(cartModel);
        }

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                RouteHelper.getProductDetailsRoute(
                  productId: widget.product.id,
                  formSearch: widget.productType == ProductType.searchItem,
                ),
              );
            },
            borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, 12)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.webDarkCard
                    : Colors.white,
                borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, 12)),
                border: Border.all(
                  color: _isHovered
                      ? AppColors.webPrimaryBlue.withValues(alpha: 0.3)
                      : Colors.grey.shade200,
                  width: 1,
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: AppColors.webPrimaryBlue.withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image with Discount Badge
                  Expanded(
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(ResponsiveDimensions.padding(context, 12)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, 8)),
                              child: CustomImageWidget(
                                image: Provider.of<SplashProvider>(context, listen: false)
                                            .baseUrls !=
                                        null
                                    ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.productImageUrl}/${(widget.product.image?.isNotEmpty ?? false) ? widget.product.image![0] : ''}'
                                    : '',
                                fit: BoxFit.contain,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ),

                        // Discount Badge
                        if (widget.product.discount != null &&
                            widget.product.discount! > 0)
                          Positioned(
                            top: ResponsiveDimensions.scale(context, 8),
                            left: ResponsiveDimensions.scale(context, 8),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveDimensions.padding(context, 8),
                                  vertical: ResponsiveDimensions.padding(context, 4)),
                              decoration: BoxDecoration(
                                color: AppColors.webPrimaryBlue,
                                borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, 4)),
                              ),
                              child: Text(
                                widget.product.discountType == 'percent'
                                    ? '${widget.product.discount?.toStringAsFixed(0)}%'
                                    : '-${PriceConverterHelper.convertPrice(context, widget.product.discount)}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ResponsiveDimensions.fontSize(context, 12),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Product Info
                  Padding(
                    padding: EdgeInsets.all(ResponsiveDimensions.padding(context, 12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name - Single Line
                        Text(
                          widget.product.name ?? '',
                          style: TextStyle(
                            fontSize: ResponsiveDimensions.fontSize(context, 14),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: ResponsiveDimensions.padding(context, 8)),

                        // Price Section
                        Row(
                          children: [
                            // Current Price
                            CustomDirectionalityWidget(
                              child: Text(
                                PriceConverterHelper.convertPrice(
                                    context, priceWithDiscount),
                                style: TextStyle(
                                  fontSize: ResponsiveDimensions.fontSize(context, 16),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins',
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),

                            SizedBox(width: ResponsiveDimensions.padding(context, 8)),

                            // Original Price (if discounted)
                            if (widget.product.price! > priceWithDiscount!)
                              CustomDirectionalityWidget(
                                child: Text(
                                  PriceConverterHelper.convertPrice(
                                      context, widget.product.price),
                                  style: TextStyle(
                                    fontSize: ResponsiveDimensions.fontSize(context, 13),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins',
                                    color: Colors.grey.shade500,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        SizedBox(height: ResponsiveDimensions.padding(context, 12)),

                        // ADD Button - Left aligned
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            height: ResponsiveDimensions.height(context, 36),
                            child: isExistInCart
                                ? Container(
                                    height: ResponsiveDimensions.height(context, 36),
                                    padding: EdgeInsets.symmetric(horizontal: ResponsiveDimensions.padding(context, 8)),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, 20)),
                                      border: Border.all(
                                        color: AppColors.webPrimaryBlue,
                                        width: 1,
                                      ),
                                    ),
                                  child: Consumer<CartProvider>(
                                    builder: (context, cart, child) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // Minus Button
                                        InkWell(
                                          onTap: () {
                                            if (cardIndex != null) {
                                              if (cart.cartList[cardIndex]
                                                      .quantity! >
                                                  1) {
                                                cart.setCartQuantity(false,
                                                    cardIndex,
                                                    context: context,
                                                    showMessage: true);
                                              } else {
                                                cart.removeItemFromCart(
                                                    cardIndex, context);
                                              }
                                            }
                                          },
                                          child: Icon(
                                            Icons.remove,
                                            size: ResponsiveDimensions.scale(context, 18),
                                            color: AppColors.webPrimaryBlue,
                                          ),
                                        ),

                                        // Quantity
                                        Text(
                                          cardIndex != null
                                              ? cart.cartList[cardIndex].quantity
                                                  .toString()
                                              : '0',
                                          style: TextStyle(
                                            fontSize: ResponsiveDimensions.fontSize(context, 14),
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                            color: AppColors.webPrimaryBlue,
                                          ),
                                        ),

                                        // Plus Button
                                        InkWell(
                                          onTap: () {
                                            if (cardIndex != null) {
                                              if (cart.cartList[cardIndex]
                                                          .product!
                                                          .maximumOrderQuantity ==
                                                      null ||
                                                  cart.cartList[cardIndex]
                                                          .quantity! <
                                                      cart.cartList[cardIndex]
                                                          .product!
                                                          .maximumOrderQuantity!) {
                                                if (cart.cartList[cardIndex]
                                                        .quantity! <
                                                    cart.cartList[cardIndex]
                                                        .stock!) {
                                                  cart.setCartQuantity(true,
                                                      cardIndex,
                                                      showMessage: true,
                                                      context: context);
                                                } else {
                                                  showCustomSnackBarHelper(
                                                      'out_of_stock'.tr);
                                                }
                                              } else {
                                                showCustomSnackBarHelper(
                                                    '${'you_can_add_max'.tr} ${cart.cartList[cardIndex].product!.maximumOrderQuantity} ${'items'.tr} ${'only'.tr}');
                                              }
                                            }
                                          },
                                          child: Icon(
                                            Icons.add,
                                            size: ResponsiveDimensions.scale(context, 18),
                                            color: AppColors.webPrimaryBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                : ElevatedButton(
                                    onPressed: () {
                                      if (widget.product.variations == null ||
                                          widget.product.variations!.isEmpty) {
                                        if (isExistInCart) {
                                          showCustomSnackBarHelper(
                                              'already_added'.tr);
                                        } else if (stock! < 1) {
                                          showCustomSnackBarHelper(
                                              'out_of_stock'.tr);
                                        } else {
                                          cartProvider.addToCart(cartModel!);
                                          showCustomSnackBarHelper(
                                              'added_to_cart'.tr,
                                              isError: false);
                                        }
                                      } else {
                                        Navigator.of(context).pushNamed(
                                          RouteHelper.getProductDetailsRoute(
                                            productId: widget.product.id,
                                            formSearch: widget.productType ==
                                                ProductType.searchItem,
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppColors.webPrimaryBlue,
                                      elevation: 0,
                                      minimumSize: Size(ResponsiveDimensions.width(context, 80), ResponsiveDimensions.height(context, 36)),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, 20)),
                                        side: const BorderSide(
                                          color: AppColors.webPrimaryBlue,
                                          width: 1,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ResponsiveDimensions.padding(context, 16),
                                        vertical: 0,
                                      ),
                                    ),
                                    child: Text(
                                      'ADD',
                                      style: TextStyle(
                                        fontSize: ResponsiveDimensions.fontSize(context, 13),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
