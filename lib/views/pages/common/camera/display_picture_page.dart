import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';

class DisplayPicturePage extends StatelessWidget {
  final String imagePath;
  final Function sendCameraPicture;

  const DisplayPicturePage(
      {super.key, required this.imagePath, required this.sendCameraPicture});

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
              child: Image.file(File(imagePath)),
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
        onPressed: () {
          sendCameraPicture(imagePath);
          AppRouter.pop(context);
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}
