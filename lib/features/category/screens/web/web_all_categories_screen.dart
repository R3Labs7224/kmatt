import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/web/mobile_bottom_nav_bar.dart';
import 'package:flutter_grocery/common/widgets/web/web_sidebar_menu.dart';
import 'package:flutter_grocery/common/widgets/web/web_category_drawer.dart';
import 'package:flutter_grocery/common/widgets/web/web_header_widget.dart';
import 'package:flutter_grocery/features/category/providers/category_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/responsive_dimensions.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/theme/app_colors.dart';
import 'package:flutter_grocery/theme/app_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

/// Web-specific all categories screen with modern grid layout
class WebAllCategoriesScreen extends StatelessWidget {
  const WebAllCategoriesScreen({super.key});

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
        slivers: [
          // Web Header
          const SliverToBoxAdapter(child: WebHeaderWidget()),

          // Main Content
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: ResponsiveDimensions.getMaxContentWidth(context)),
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveDimensions.getHorizontalPadding(context),
                  vertical: ResponsiveDimensions.padding(context, 48),
                ),
                child: Consumer<CategoryProvider>(
                  builder: (context, categoryProvider, child) {
                    if (categoryProvider.categoryList == null) {
                      return _buildLoadingGrid(context);
                    }

                    if (categoryProvider.categoryList!.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(ResponsiveDimensions.padding(context, 48)),
                          child: Text(
                            'No categories available',
                            style: TextStyle(
                              fontSize: ResponsiveDimensions.fontSize(context, 18),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      );
                    }

                    // Group categories by parent category if available
                    final categories = categoryProvider.categoryList!;

                    // Responsive grid columns: 3 on desktop, 2 on tablet, 1 on mobile
                    final useMobileLayout = ResponsiveDimensions.shouldUseMobileLayout(context);
                    final crossAxisCount = useMobileLayout ? 1 : ResponsiveDimensions.getGridColumns(context, desktopColumns: 3);
                    final spacing = ResponsiveDimensions.padding(context, 24);
                    final childAspectRatio = useMobileLayout ? 4.5 : 3.5;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Page Title
                        Text(
                          'All Categories',
                          style: AppTextStyles.webH3.copyWith(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            fontSize: ResponsiveDimensions.fontSize(context, 24),
                          ),
                        ),
                        SizedBox(height: ResponsiveDimensions.padding(context, 8)),
                        Text(
                          '${categories.length} Categories Available',
                          style: AppTextStyles.webBodyMedium.copyWith(
                            color: Colors.grey.shade600,
                            fontSize: ResponsiveDimensions.fontSize(context, 14),
                          ),
                        ),
                        SizedBox(height: ResponsiveDimensions.padding(context, 32)),

                        // Categories Grid
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: spacing,
                            mainAxisSpacing: spacing,
                            childAspectRatio: childAspectRatio,
                          ),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return _CategoryCard(
                              category: category,
                              baseUrl: Provider.of<SplashProvider>(context, listen: false)
                                      .baseUrls
                                      ?.categoryImageUrl ??
                                  '',
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // Footer
          const FooterWebWidget(footerType: FooterType.sliver),
        ],
      ),
    );
  }

  Widget _buildLoadingGrid(BuildContext context) {
    final useMobileLayout = ResponsiveDimensions.shouldUseMobileLayout(context);
    final crossAxisCount = useMobileLayout ? 1 : ResponsiveDimensions.getGridColumns(context, desktopColumns: 3);
    final spacing = ResponsiveDimensions.padding(context, 24);
    final childAspectRatio = useMobileLayout ? 4.5 : 3.5;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: 12,
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

class _CategoryCard extends StatefulWidget {
  final dynamic category;
  final String baseUrl;

  const _CategoryCard({
    required this.category,
    required this.baseUrl,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final borderRadius = ResponsiveDimensions.scale(context, 12);
    final padding = ResponsiveDimensions.padding(context, 16);
    final imageSize = ResponsiveDimensions.scale(context, 60);
    final imageRadius = ResponsiveDimensions.scale(context, 8);
    final spacing = ResponsiveDimensions.padding(context, 16);
    final fontSize = ResponsiveDimensions.fontSize(context, 16);
    final iconSize = ResponsiveDimensions.scale(context, 18);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            RouteHelper.getCategoryProductsRoute(categoryId: '${widget.category.id}'),
          );
        },
        borderRadius: BorderRadius.circular(borderRadius),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.webDarkCard
                : Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: _isHovered
                  ? AppColors.webPrimaryBlue.withValues(alpha: 0.3)
                  : Colors.grey.shade200,
              width: ResponsiveDimensions.scale(context, 1),
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.webPrimaryBlue.withValues(alpha: 0.15),
                      blurRadius: ResponsiveDimensions.scale(context, 12),
                      offset: Offset(0, ResponsiveDimensions.scale(context, 4)),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: ResponsiveDimensions.scale(context, 4),
                      offset: Offset(0, ResponsiveDimensions.scale(context, 2)),
                    ),
                  ],
          ),
          child: Row(
            children: [
              // Category Image
              Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(imageRadius),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(imageRadius),
                  child: CustomImageWidget(
                    image: '${widget.baseUrl}/${widget.category.image}',
                    fit: BoxFit.cover,
                    width: imageSize,
                    height: imageSize,
                  ),
                ),
              ),

              SizedBox(width: spacing),

              // Category Name
              Expanded(
                child: Text(
                  widget.category.name ?? '',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: _isHovered
                        ? AppColors.webPrimaryBlue
                        : Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Arrow Icon
              Icon(
                Icons.arrow_forward_ios,
                size: iconSize,
                color: _isHovered ? AppColors.webPrimaryBlue : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
