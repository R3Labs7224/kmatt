import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/features/category/domain/models/category_model.dart';
import 'package:flutter_grocery/features/category/providers/category_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/theme/app_colors.dart';
import 'package:provider/provider.dart';

class WebCategoryDrawer extends StatelessWidget {
  const WebCategoryDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 550,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Shop By Category',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<CategoryProvider>(
              builder: (context, categoryProvider, child) {
                final categories = categoryProvider.categoryList;

                if (categories == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: categories.length + 1,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    if (index == categories.length) {
                      return _buildAllCategoriesItem(context);
                    }

                    final category = categories[index];
                    return _buildCategoryItem(context, category, index == 0);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, CategoryModel category, bool isFirst) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).pushNamed(
          RouteHelper.getCategoryProductsRoute(categoryId: '${category.id}'),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8, top: isFirst ? 8 : 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isFirst ? const Color(0xFFFFF5F5) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isFirst ? Colors.transparent : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CustomImageWidget(
                  image: splashProvider.baseUrls != null
                      ? '${splashProvider.baseUrls!.categoryImageUrl}/${category.image}'
                      : '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                category.name ?? '',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: isFirst ? FontWeight.w600 : FontWeight.w500,
                  fontFamily: 'Poppins',
                  color: isFirst ? AppColors.webPrimaryBlue : Colors.black,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllCategoriesItem(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).pushNamed(RouteHelper.categories);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 16, bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 66),
            const Expanded(
              child: Text(
                'All Categories',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: AppColors.webPrimaryBlue,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: AppColors.webPrimaryBlue,
            ),
          ],
        ),
      ),
    );
  }
}
