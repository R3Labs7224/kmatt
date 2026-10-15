import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/features/category/providers/category_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/theme/app_colors.dart';
import 'package:provider/provider.dart';

/// Horizontal scrollable category navigation bar
class WebHorizontalCategoriesWidget extends StatelessWidget {
  final String? selectedCategoryId;

  const WebHorizontalCategoriesWidget({
    super.key,
    this.selectedCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, _) {
        if (categoryProvider.categoryList == null || categoryProvider.categoryList!.isEmpty) {
          return const SizedBox();
        }

        final categories = categoryProvider.categoryList!;
        final splashProvider = Provider.of<SplashProvider>(context, listen: false);

        return Container(
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.webDarkCard
                : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategoryId == '${category.id}';

              return _HorizontalCategoryItem(
                category: category,
                baseUrl: splashProvider.baseUrls?.categoryImageUrl ?? '',
                isSelected: isSelected,
              );
            },
          ),
        );
      },
    );
  }
}

class _HorizontalCategoryItem extends StatefulWidget {
  final dynamic category;
  final String baseUrl;
  final bool isSelected;

  const _HorizontalCategoryItem({
    required this.category,
    required this.baseUrl,
    required this.isSelected,
  });

  @override
  State<_HorizontalCategoryItem> createState() => _HorizontalCategoryItemState();
}

class _HorizontalCategoryItemState extends State<_HorizontalCategoryItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(
            RouteHelper.getCategoryProductsRoute(categoryId: '${widget.category.id}'),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.webPrimaryBlue.withValues(alpha: 0.1)
                : _isHovered
                    ? Colors.grey.shade100
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.webPrimaryBlue
                  : _isHovered
                      ? Colors.grey.shade300
                      : Colors.transparent,
              width: widget.isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Category Image
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CustomImageWidget(
                    image: '${widget.baseUrl}/${widget.category.image}',
                    fit: BoxFit.cover,
                    width: 40,
                    height: 40,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Category Name
              Text(
                widget.category.name ?? '',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: widget.isSelected
                      ? AppColors.webPrimaryBlue
                      : _isHovered
                          ? Colors.black87
                          : Colors.black54,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
