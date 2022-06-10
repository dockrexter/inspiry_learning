import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CommonNetworkImageView extends StatelessWidget {
  ///[url] is required parameter for fetching network image
  final String url;
  final double height;
  final double width;
  final BoxFit fit;
  final String placeHolder;

  ///a [CommonNetworkImageView] it can be used for showing any network images
  /// it will shows the placeholder image if image is not found on network
  const CommonNetworkImageView({Key? key, 
    required this.url,
    this.height = 200,
    this.width = 200,
    this.fit = BoxFit.contain,
    this.placeHolder = 'assets/images/image_not_found.png',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return url.isEmpty
        ? Image.asset(
            placeHolder,
            height: height,
            width: width,
            fit: fit,
          )
        : CachedNetworkImage(
            height: height,
            width: width,
            fit: fit,
            imageUrl: url,
            placeholder: (context, url) => SizedBox(
              height: 30.h,
              width: 30.h,
              child: LinearProgressIndicator(
                color: Colors.grey.shade200,
                backgroundColor: Colors.grey.shade100,
              ),
            ),
            errorWidget: (context, url, error) => Image.asset(
              placeHolder,
              height: height,
              width: width,
              fit: fit,
            ),
          );
  }
}
