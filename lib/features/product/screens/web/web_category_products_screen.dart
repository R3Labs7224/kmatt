import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/web/mobile_bottom_nav_bar.dart';
import 'package:flutter_grocery/common/widgets/web/web_sidebar_menu.dart';
import 'package:flutter_grocery/common/widgets/web/web_category_drawer.dart';
import 'package:flutter_grocery/common/widgets/web/web_header_widget.dart';
import 'package:flutter_grocery/common/widgets/web/web_horizontal_categories_widget.dart';
import 'package:flutter_grocery/common/widgets/web/web_product_card.dart';
import 'package:flutter_grocery/features/category/providers/category_provider.dart';
import 'package:flutter_grocery/helper/responsive_dimensions.dart';
import 'package:flutter_grocery/theme/app_colors.dart';
import 'package:flutter_grocery/theme/app_text_styles.dart';
import 'package:flutter_grocery/utill/product_type.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

/// Web-specific category products screen with modern design
class WebCategoryProductsScreen extends StatefulWidget {
  final String categoryId;
  final String? subCategoryName;

  const WebCategoryProductsScreen({
    super.key,
    required this.categoryId,
    this.subCategoryName,
  });

  @override
  State<WebCategoryProductsScreen> createState() => _WebCategoryProductsScreenState();
}

class _WebCategoryProductsScreenState extends State<WebCategoryProductsScreen> {
  final ScrollController _scrollController = ScrollController();

  // Expandable sections
  bool _isPriceExpanded = true;

  // Price range filter
  RangeValues _priceRange = const RangeValues(0, 10000);

  // Loading state
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategoryProducts();
  }

  void _loadCategoryProducts() {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

    // Load category details
    categoryProvider.getCategory(int.tryParse(widget.categoryId), context);

    // Load subcategories
    categoryProvider.getSubCategoryList(context, widget.categoryId);

    // Load category products
    categoryProvider.initCategoryProductList(widget.categoryId);

    // Set loading to false after a short delay to allow data to load
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  List<Product> _getFilteredProducts() {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final products = categoryProvider.categoryProductList;

    // Apply price filter
    return products.where((product) {
      final price = product.price ?? 0;
      if (price < _priceRange.start || price > _priceRange.end) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.webDarkBackground
          : const Color(0xFFF8F9FA),
      drawer: const WebCategoryDrawer(),
      endDrawer: const WebSidebarMenu(),
      bottomNavigationBar: const MobileBottomNavBar(currentIndex: 1),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Web Header
          const SliverToBoxAdapter(child: WebHeaderWidget()),

          // Horizontal Category Navigation
          SliverToBoxAdapter(
            child: WebHorizontalCategoriesWidget(
              selectedCategoryId: widget.categoryId,
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final useMobileLayout = ResponsiveDimensions.shouldUseMobileLayout(context);
                final screenWidth = MediaQuery.of(context).size.width;

                return Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: ResponsiveDimensions.getMaxContentWidth(context)),
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveDimensions.getHorizontalPadding(context),
                      vertical: ResponsiveDimensions.padding(context, 24),
                    ),
                    child: useMobileLayout
                        ? _buildMobileLayout()
                        : _buildDesktopLayout(screenWidth),
                  ),
                );
              },
            ),
          ),

          // Footer
          const FooterWebWidget(footerType: FooterType.sliver),
        ],
      ),
    );
  }

  // Mobile layout: Filter on top, products below
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Page Title
        Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            return Text(
              categoryProvider.categoryModel?.name ?? 'Category Products',
              style: AppTextStyles.webH4.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                fontSize: ResponsiveDimensions.fontSize(context, 24),
              ),
            );
          },
        ),
        SizedBox(height: ResponsiveDimensions.padding(context, 8)),
        Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            final filteredProducts = _getFilteredProducts();
            return Text(
              '${filteredProducts.length} Products',
              style: AppTextStyles.webBodyMedium.copyWith(
                color: Colors.grey.shade600,
                fontSize: ResponsiveDimensions.fontSize(context, 14),
              ),
            );
          },
        ),

        SizedBox(height: ResponsiveDimensions.padding(context, 20)),

        // Price Filter - Horizontal on mobile
        Container(
          padding: EdgeInsets.all(ResponsiveDimensions.padding(context, 16)),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.webDarkCard
                : Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, 12)),
            border: Border.all(color: Colors.grey.shade200, width: ResponsiveDimensions.scale(context, 1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price Range',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.fontSize(context, 14),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: ResponsiveDimensions.padding(context, 8)),
              RangeSlider(
                values: _priceRange,
                min: 0,
                max: 10000,
                divisions: 100,
                activeColor: AppColors.webPrimaryBlue,
                labels: RangeLabels(
                  'KES ${_priceRange.start.round()}',
                  'KES ${_priceRange.end.round()}',
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _priceRange = values;
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveDimensions.padding(context, 8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'KES ${_priceRange.start.round()}',
                      style: TextStyle(
                        fontSize: ResponsiveDimensions.fontSize(context, 12),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      'KES ${_priceRange.end.round()}',
                      style: TextStyle(
                        fontSize: ResponsiveDimensions.fontSize(context, 12),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: ResponsiveDimensions.padding(context, 20)),

        // Products Grid
        _buildProductsGrid(2), // 2 columns on mobile
      ],
    );
  }

  // Desktop layout: Filter sidebar on left, products on right
  Widget _buildDesktopLayout(double screenWidth) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Sidebar - Filters
        Container(
          width: ResponsiveDimensions.scale(context, 280),
          padding: EdgeInsets.all(ResponsiveDimensions.padding(context, 20)),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.webDarkCard
                : Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, 12)),
            border: Border.all(color: Colors.grey.shade200, width: ResponsiveDimensions.scale(context, 1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Price Filter Section
              _buildFilterSection(
                title: 'Price Range',
                isExpanded: _isPriceExpanded,
                onToggle: () {
                  setState(() {
                    _isPriceExpanded = !_isPriceExpanded;
                  });
                },
                child: Column(
                  children: [
                    SizedBox(height: ResponsiveDimensions.padding(context, 16)),
                    RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: 10000,
                      divisions: 100,
                      activeColor: AppColors.webPrimaryBlue,
                      labels: RangeLabels(
                        'KES ${_priceRange.start.round()}',
                        'KES ${_priceRange.end.round()}',
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _priceRange = values;
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: ResponsiveDimensions.padding(context, 8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'KES ${_priceRange.start.round()}',
                            style: TextStyle(
                              fontSize: ResponsiveDimensions.fontSize(context, 13),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'KES ${_priceRange.end.round()}',
                            style: TextStyle(
                              fontSize: ResponsiveDimensions.fontSize(context, 13),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: ResponsiveDimensions.padding(context, 24)),

        // Right Side - Product Grid
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Title
              Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child) {
                  return Text(
                    categoryProvider.categoryModel?.name ?? 'Category Products',
                    style: AppTextStyles.webH4.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      fontSize: ResponsiveDimensions.fontSize(context, 24),
                    ),
                  );
                },
              ),
              SizedBox(height: ResponsiveDimensions.padding(context, 8)),
              Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child) {
                  final filteredProducts = _getFilteredProducts();
                  return Text(
                    '${filteredProducts.length} Products',
                    style: AppTextStyles.webBodyMedium.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: ResponsiveDimensions.fontSize(context, 14),
                    ),
                  );
                },
              ),

              SizedBox(height: ResponsiveDimensions.padding(context, 24)),

              // Products Grid - Variable columns based on screen width
              _buildProductsGrid(
                screenWidth < 1300 ? 3 : (screenWidth < 1600 ? 4 : 5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Product grid builder
  Widget _buildProductsGrid(int crossAxisCount) {
    if (_isLoading) {
      return _buildLoadingGrid(crossAxisCount);
    }

    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        final filteredProducts = _getFilteredProducts();

        if (filteredProducts.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(ResponsiveDimensions.padding(context, 48)),
              child: Column(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: ResponsiveDimensions.scale(context, 80),
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: ResponsiveDimensions.padding(context, 16)),
                  Text(
                    'No products found',
                    style: AppTextStyles.webH3.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: ResponsiveDimensions.fontSize(context, 20),
                    ),
                  ),
                  SizedBox(height: ResponsiveDimensions.padding(context, 8)),
                  Text(
                    'Try adjusting your filters',
                    style: AppTextStyles.webBodyMedium.copyWith(
                      color: Colors.grey.shade500,
                      fontSize: ResponsiveDimensions.fontSize(context, 14),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final spacing = ResponsiveDimensions.padding(context, 20);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: 0.75,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            return WebProductCard(
              product: filteredProducts[index],
              productType: ProductType.featuredItem,
            );
          },
        );
      },
    );
  }

  Widget _buildFilterSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveDimensions.fontSize(context, 16),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                size: ResponsiveDimensions.scale(context, 24),
              ),
            ],
          ),
        ),
        if (isExpanded) child,
        SizedBox(height: ResponsiveDimensions.padding(context, 20)),
        Divider(color: Colors.grey.shade300, height: ResponsiveDimensions.scale(context, 1)),
        SizedBox(height: ResponsiveDimensions.padding(context, 20)),
      ],
    );
  }

  Widget _buildLoadingGrid(int crossAxisCount) {
    final spacing = ResponsiveDimensions.padding(context, 20);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 0.75,
      ),
      itemCount: 10, // Show 10 shimmer placeholders
      itemBuilder: (context, index) {
        return Shimmer(
          duration: const Duration(seconds: 2),
          color: Colors.grey[300]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(ResponsiveDimensions.scale(context, 12)),
            ),
          ),
        );
      },
    );
  }
}
