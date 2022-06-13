import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/globals/app_colors.dart';
import 'package:inspiry_learning/globals/app_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DisplayPicturePage extends StatelessWidget {
  final String imagePath;

  const DisplayPicturePage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SizedBox(
        width: ScreenSize.width,
        height: ScreenSize.height,
        child: Stack(
          children: [
            SizedBox(
              width: ScreenSize.width,
              height: ScreenSize.height,
              child: Image.file(
                File(imagePath),
              ),
            ),
            Positioned(
              top: 50.h,
              left: 12.w,
              child: IconButton(
                onPressed: () => AppRouter.pop(context),
                icon: Icon(
                  Icons.close_sharp,
                  color: AppColors.white,
                  size: 30.w,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppRouter.pop(context),
        child: const Icon(Icons.send),
      ),
    );
  }
}
