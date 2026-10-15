import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/common/providers/product_provider.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/web/web_sidebar_menu.dart';
import 'package:flutter_grocery/common/widgets/web/web_category_drawer.dart';
import 'package:flutter_grocery/common/widgets/web/web_header_widget.dart';
import 'package:flutter_grocery/common/widgets/web/web_product_card.dart';
import 'package:flutter_grocery/features/category/providers/category_provider.dart';
import 'package:flutter_grocery/features/home/providers/flash_deal_provider.dart';
import 'package:flutter_grocery/theme/app_colors.dart';
import 'package:flutter_grocery/theme/app_text_styles.dart';
import 'package:flutter_grocery/utill/product_type.dart';
import 'package:provider/provider.dart';

/// Web-specific product listing screen matching the screenshot design
class WebHomeItemScreen extends StatefulWidget {
  final String productType;

  const WebHomeItemScreen({
    super.key,
    required this.productType,
  });

  @override
  State<WebHomeItemScreen> createState() => _WebHomeItemScreenState();
}

class _WebHomeItemScreenState extends State<WebHomeItemScreen> {
  final ScrollController _scrollController = ScrollController();

  // Expandable sections
  bool _isCategoriesExpanded = true;
  bool _isPriceExpanded = true;

  // Price range filter
  RangeValues _priceRange = const RangeValues(0, 10000);

  // Selected categories (using int to match CategoryModel.id)
  final Set<int> _selectedCategoryIds = {};

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final flashDealProvider = Provider.of<FlashDealProvider>(context, listen: false);

    switch (widget.productType) {
      case ProductType.dailyItem:
        if (productProvider.dailyProductModel == null) {
          productProvider.getItemList(1, isUpdate: false, productType: ProductType.dailyItem);
        }
        break;
      case ProductType.featuredItem:
        if (productProvider.featuredProductModel == null) {
          productProvider.getItemList(1, isUpdate: false, productType: ProductType.featuredItem);
        }
        break;
      case ProductType.mostReviewed:
        if (productProvider.mostViewedProductModel == null) {
          productProvider.getItemList(1, isUpdate: false, productType: ProductType.mostReviewed);
        }
        break;
      case ProductType.flashSale:
        if (flashDealProvider.flashDealModel == null) {
          flashDealProvider.getFlashDealProducts(1, isUpdate: false);
        }
        break;
    }
  }

  String _getPageTitle() {
    switch (widget.productType) {
      case ProductType.dailyItem:
        return 'Care Essentials';
      case ProductType.featuredItem:
        return 'Featured Products';
      case ProductType.mostReviewed:
        return 'Most Reviewed';
      case ProductType.flashSale:
        return 'Promotions';
      default:
        return 'Products';
    }
  }

  List<Product> _getFilteredProducts() {
    final products = _getAllProducts();

    // Apply filters
    return products.where((product) {
      // Price filter
      final price = product.price ?? 0;
      if (price < _priceRange.start || price > _priceRange.end) {
        return false;
      }

      // Category filter - only apply if categories are selected
      if (_selectedCategoryIds.isNotEmpty) {
        if (product.categoryIds == null || product.categoryIds!.isEmpty) {
          return false;
        }

        // Check if any of the product's categories match selected categories
        // Convert both to strings for comparison since CategoryIds stores strings
        final productCategoryIdStrings = product.categoryIds!
            .where((catId) => catId.id != null)
            .map((catId) => catId.id!)
            .toSet();

        // Convert selected int IDs to strings and check for overlap
        final selectedCategoryIdStrings = _selectedCategoryIds.map((id) => id.toString()).toSet();

        final hasMatch = productCategoryIdStrings.intersection(selectedCategoryIdStrings).isNotEmpty;

        if (!hasMatch) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  List<Product> _getAllProducts() {
    // Note: Using context without listen: false here since this is called
    // within a Consumer2 widget which already handles listening
    final productProvider = context.read<ProductProvider>();
    final flashDealProvider = context.read<FlashDealProvider>();

    switch (widget.productType) {
      case ProductType.dailyItem:
        return productProvider.dailyProductModel?.products ?? [];
      case ProductType.featuredItem:
        return productProvider.featuredProductModel?.products ?? [];
      case ProductType.mostReviewed:
        return productProvider.mostViewedProductModel?.products ?? [];
      case ProductType.flashSale:
        return flashDealProvider.flashDealModel?.products ?? [];
      default:
        return [];
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
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Main Content
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1555),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Sidebar - Filters
                    SizedBox(
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Categories Filter
                          _buildFilterSection(
                            title: 'Categories',
                            isExpanded: _isCategoriesExpanded,
                            onToggle: () {
                              setState(() {
                                _isCategoriesExpanded = !_isCategoriesExpanded;
                              });
                            },
                            child: _buildCategoryFilters(),
                          ),

                          const SizedBox(height: 24),

                          // Price Filter
                          _buildFilterSection(
                            title: 'Price (KES)',
                            isExpanded: _isPriceExpanded,
                            onToggle: () {
                              setState(() {
                                _isPriceExpanded = !_isPriceExpanded;
                              });
                            },
                            child: _buildPriceFilter(),
                          ),

                        ],
                      ),
                    ),

                    const SizedBox(width: 24),

                    // Right Content - Products Grid
                    Expanded(
                      child: Consumer2<ProductProvider, FlashDealProvider>(
                        builder: (context, productProvider, flashDealProvider, _) {
                          final products = _getFilteredProducts();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Page Title and Results Count
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Search Results For "${_getPageTitle()}"',
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${products.length} Item(s)',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 32),

                              // Products Grid
                              if (products.isEmpty)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(64),
                                    child: Text(
                                      'No products found',
                                      style: AppTextStyles.webBodyLarge.copyWith(
                                        color: Theme.of(context).textTheme.bodyMedium?.color,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    childAspectRatio: 0.65,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 20,
                                  ),
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    return WebProductCard(
                                      product: products[index],
                                      productType: widget.productType,
                                    );
                                  },
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            const FooterWebWidget(footerType: FooterType.nonSliver),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.webDarkCard
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggle,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 24,
                ),
              ],
            ),
          ),
          if (isExpanded) ...[
            const SizedBox(height: 16),
            child,
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, _) {
        final categories = categoryProvider.categoryList ?? [];

        if (categories.isEmpty) {
          return const Text(
            'Loading categories...',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
            ),
          );
        }

        // Show first 6 categories
        final displayCategories = categories.take(6).toList();

        return Column(
          children: displayCategories.map((category) {
            final isSelected = category.id != null && _selectedCategoryIds.contains(category.id);
            return CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                category.name ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),
              value: isSelected,
              activeColor: AppColors.webPrimaryBlue,
              onChanged: (value) {
                setState(() {
                  if (value == true && category.id != null) {
                    _selectedCategoryIds.add(category.id!);
                  } else if (category.id != null) {
                    _selectedCategoryIds.remove(category.id!);
                  }
                });
              },
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildPriceFilter() {
    return Column(
      children: [
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 10000,
          divisions: 100,
          activeColor: AppColors.webPrimaryBlue,
          inactiveColor: Colors.grey.shade300,
          labels: RangeLabels(
            'KES ${_priceRange.start.round()}',
            'KES ${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'KES ${_priceRange.start.round()}',
              style: const TextStyle(
                fontSize: 13,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              'KES ${_priceRange.end.round()}',
              style: const TextStyle(
                fontSize: 13,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ],
    );
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
