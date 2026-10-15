import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/images.dart';

class CustomImageWidget extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit fit;
  final bool isNotification;
  final String placeholder;
  final bool useIconPlaceholder;

  const CustomImageWidget({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.isNotification = false,
    this.placeholder = '',
    this.useIconPlaceholder = false,
  });

  Widget _buildIconPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.white,
      child: Center(
        child: Image.asset(
          'assets/image/app_logo.png',
          width: (width != null && width! > 200) ? width! * 0.4 : 120,
          height: (height != null && height! > 200) ? height! * 0.4 : 80,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (useIconPlaceholder) {
      return CachedNetworkImage(
        imageUrl: kIsWeb ? '${AppConstants.baseUrl}/image-proxy?url=$image' : image,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) => _buildIconPlaceholder(),
        errorWidget: (context, url, error) => _buildIconPlaceholder(),
      );
    }

    final placeholderImage = placeholder.isNotEmpty ? placeholder : Images.placeHolder;
    return CachedNetworkImage(
      imageUrl: kIsWeb ? '${AppConstants.baseUrl}/image-proxy?url=$image' : image, height: height, width: width, fit: fit,
      placeholder: (context, url) => CustomAssetImageWidget(placeholderImage, height: height, width: width, fit: fit,),
      errorWidget: (context, url, error) => CustomAssetImageWidget(placeholderImage, height: height, width: width, fit: fit,),
    );
  }
}
