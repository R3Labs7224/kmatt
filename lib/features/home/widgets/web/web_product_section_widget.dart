import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/common/widgets/web/web_product_card.dart';
import 'package:flutter_grocery/helper/responsive_dimensions.dart';
import 'package:flutter_grocery/theme/app_colors.dart';
import 'package:flutter_grocery/theme/app_text_styles.dart';

/// Product section with title and grid layout for web - Fully responsive
class WebProductSectionWidget extends StatefulWidget {
  final String title;
  final List<Product> products;
  final String productType;
  final bool showViewAll;
  final VoidCallback? onViewAll;

  const WebProductSectionWidget({
    super.key,
    required this.title,
    required this.products,
    required this.productType,
    this.showViewAll = false,
    this.onViewAll,
  });

  @override
  State<WebProductSectionWidget> createState() => _WebProductSectionWidgetState();
}

class _WebProductSectionWidgetState extends State<WebProductSectionWidget> {
  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 800,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 800,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive dimensions
    final useMobileLayout = ResponsiveDimensions.shouldUseMobileLayout(context);
    final screenWidth = MediaQuery.of(context).size.width;

    // Mobile: use screen-width-based card size (30% smaller), Desktop: use fixed base
    final cardWidth = useMobileLayout
        ? (screenWidth * 0.294).clamp(100.0, 140.0)  // 30% smaller: 42% * 0.7 = 29.4%, between 100-140px
        : ResponsiveDimensions.width(context, 200);
    final cardHeight = useMobileLayout
        ? cardWidth * 1.85  // Maintain aspect ratio for mobile
        : ResponsiveDimensions.height(context, 380);
    final spacing = ResponsiveDimensions.padding(context, 12);
    // Mobile: 20% larger arrows (20 * 1.2 = 24), Desktop: normal
    final arrowSize = useMobileLayout
        ? ResponsiveDimensions.scale(context, 24)
        : ResponsiveDimensions.scale(context, 20);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with Navigation Arrows
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                widget.title,
                style: AppTextStyles.webH3.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: ResponsiveDimensions.fontSize(context, 24),
                ),
              ),
            ),

            // Navigation Arrows
            Row(
              children: [
                // Left Arrow
                CircleAvatar(
                  radius: arrowSize,
                  backgroundColor: Colors.grey.shade300,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black, size: arrowSize * 0.9),
                    onPressed: _scrollLeft,
                    padding: EdgeInsets.zero,
                  ),
                ),

                SizedBox(width: spacing),

                // Right Arrow
                CircleAvatar(
                  radius: arrowSize,
                  backgroundColor: Colors.grey.shade300,
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward, color: Colors.black, size: arrowSize * 0.9),
                    onPressed: _scrollRight,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: ResponsiveDimensions.padding(context, 32)),

        // Products Horizontal Scroll
        SizedBox(
          height: cardHeight,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.products.length,
            itemBuilder: (context, index) {
              return Container(
                width: cardWidth,
                margin: EdgeInsets.only(right: spacing),
                child: WebProductCard(
                  product: widget.products[index],
                  productType: widget.productType,
                ),
              );
            },
          ),
        ),

        SizedBox(height: ResponsiveDimensions.padding(context, 24)),

        // View All Button
        if (widget.showViewAll)
          Center(
            child: TextButton.icon(
              onPressed: widget.onViewAll,
              icon: Text(
                'View All',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.fontSize(context, 15),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: AppColors.webPrimaryBlue,
                ),
              ),
              label: Icon(
                Icons.arrow_forward,
                size: ResponsiveDimensions.scale(context, 20),
                color: AppColors.webPrimaryBlue,
              ),
            ),
          ),
      ],
    );
  }
}
