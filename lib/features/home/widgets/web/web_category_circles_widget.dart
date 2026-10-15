import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/features/category/providers/category_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/responsive_dimensions.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/theme/app_colors.dart';
import 'package:flutter_grocery/theme/app_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

/// Best-Selling Categories section with circular images - Fully responsive
class WebCategoryCirclesWidget extends StatelessWidget {
  const WebCategoryCirclesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, _) {
        if (categoryProvider.categoryList == null) {
          return _buildShimmer();
        }

        if (categoryProvider.categoryList!.isEmpty) {
          return const SizedBox();
        }

        // Show max 8 categories
        final displayCategories = categoryProvider.categoryList!.take(8).toList();

        // Responsive sizing based on mobile layout
        final useMobileLayout = ResponsiveDimensions.shouldUseMobileLayout(context);
        final circleSize = useMobileLayout
            ? ResponsiveDimensions.width(context, 80)  // Smaller on mobile (80px instead of 120px)
            : ResponsiveDimensions.width(context, 120); // Desktop size
        final fontSize = ResponsiveDimensions.fontSize(context, 13);
        final spacing = ResponsiveDimensions.padding(context, 24);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Best-Selling Categories',
              style: AppTextStyles.webH3.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: ResponsiveDimensions.fontSize(context, 24),
              ),
            ),

            SizedBox(height: ResponsiveDimensions.padding(context, 32)),

            LayoutBuilder(
              builder: (context, constraints) {
                // Responsive: 8 columns on desktop, 6 on tablet, 4 on mobile
                int crossAxisCount = 8;
                if (constraints.maxWidth < 1200) {
                  crossAxisCount = 6;
                }
                if (constraints.maxWidth < 768) {
                  crossAxisCount = 4;
                }

                return Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                      ),
                      itemCount: displayCategories.length,
                      itemBuilder: (context, index) {
                        final category = displayCategories[index];
                        return _CategoryCircleItem(
                          category: category,
                          baseUrl: Provider.of<SplashProvider>(context, listen: false).baseUrls?.categoryImageUrl ?? '',
                          circleSize: circleSize,
                          fontSize: fontSize,
                        );
                      },
                    ),
                    SizedBox(height: ResponsiveDimensions.padding(context, 32)),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushNamed(RouteHelper.categories);
                      },
                      icon: Text(
                        'View All Categories',
                        style: AppTextStyles.webLabelLarge.copyWith(
                          color: AppColors.webPrimaryBlue,
                        ),
                      ),
                      label: Icon(
                        Icons.arrow_forward,
                        size: 20,
                        color: AppColors.webPrimaryBlue,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer(
          duration: const Duration(seconds: 2),
          color: Colors.grey[300]!,
          child: Container(
            width: 300,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 32),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
            childAspectRatio: 0.85,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            return Shimmer(
              duration: const Duration(seconds: 2),
              color: Colors.grey[300]!,
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 80,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CategoryCircleItem extends StatefulWidget {
  final dynamic category;
  final String baseUrl;
  final double circleSize;
  final double fontSize;

  const _CategoryCircleItem({
    required this.category,
    required this.baseUrl,
    required this.circleSize,
    required this.fontSize,
  });

  @override
  State<_CategoryCircleItem> createState() => _CategoryCircleItemState();
}

class _CategoryCircleItemState extends State<_CategoryCircleItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            RouteHelper.getCategoryProductsRoute(categoryId: '${widget.category.id}'),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: _isHovered ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: widget.circleSize,
                  height: widget.circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.webDarkCard
                        : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: _isHovered
                            ? AppColors.webPrimaryBlue.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.08),
                        blurRadius: _isHovered ? 16 : 8,
                        offset: Offset(0, _isHovered ? 4 : 2),
                      ),
                    ],
                  ),
                  child: Builder(
                    builder: (context) {
                      final useMobileLayout = ResponsiveDimensions.shouldUseMobileLayout(context);
                      // Mobile: 96% (0.8 * 1.2), Desktop: 80%
                      final imageScale = useMobileLayout ? 0.96 : 0.8;
                      final padding = useMobileLayout ? widget.circleSize * 0.02 : widget.circleSize * 0.1;

                      return Padding(
                        padding: EdgeInsets.all(padding),
                        child: ClipOval(
                          child: CustomImageWidget(
                            image: '${widget.baseUrl}/${widget.category.image}',
                            fit: BoxFit.cover,
                            width: widget.circleSize * imageScale,
                            height: widget.circleSize * imageScale,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: widget.circleSize * 0.1),

              Text(
                widget.category.name ?? '',
                style: TextStyle(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  color: _isHovered
                      ? AppColors.webPrimaryBlue
                      : Theme.of(context).textTheme.bodyMedium?.color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
