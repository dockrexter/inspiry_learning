import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/models/assignment_model.dart';
import 'package:inspiry_learning/models/attachment_model.dart';
import 'package:inspiry_learning/views/widgets/custom_card.dart';
import 'package:inspiry_learning/repositories/attachment_repositories.dart';

class AssignmentDetailsPage extends StatefulWidget {
  const AssignmentDetailsPage({Key? key, required this.assignment})
      : super(key: key);

  final Assignment? assignment;

  @override
  State<AssignmentDetailsPage> createState() => _AssignmentDetailsPageState();
}

class _AssignmentDetailsPageState extends State<AssignmentDetailsPage> {
  List<Attachment>? _attachments;
    final _isAdmin = UserTypeHelper.isAdmin();

  void getAttachments() {
    AttachmentRepository()
        .getAttachment(widget.assignment!.id)
        .then((attachments) {
      setState(() {
        _attachments = attachments;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getAttachments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          SizedBox(
            height: ScreenSize.height * 0.16,
            child: SafeArea(
              child: Row(
                children: [
                  SizedBox(width: 8.w),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: AppColors.white,
                    ),
                    onPressed: () => AppRouter.pop(context),
                  ),
                  const Spacer(),
                  Text(
                    AppStrings.assignmentDetails,
                    style: AppStyle.textstyleinterbold23.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding:
                  EdgeInsets.only(left: 0, right: 0, top: 12.h, bottom: 6.h),
              decoration: BoxDecoration(
                color: AppColors.gray100,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.19),
                    blurRadius: 8.r,
                    offset: const Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40.r),
                  topLeft: Radius.circular(40.r),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   _isAdmin ? CustomCard2(
                        assignment: widget.assignment, onSelected: (_) {}) : SizedBox(width: ScreenSize.width),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.description,
                            style: AppStyle.textstyleinterbold23.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            widget.assignment!.summary ?? '',
                            style: AppStyle.textstylepoppinsregular14.copyWith(color: AppColors.bluegray90099),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            AppStrings.attachments,
                            style: AppStyle.textstylepoppinssemibold12.copyWith(
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          if (_attachments != null)
                            ..._buildImagesGrid(
                              context,
                              // imagesPath: [],
                              imagesPath: _attachments!
                                  .map((e) => e.downloadUrl!)
                                  .toList(),
                            )
                          else
                            Text(
                              AppStrings.noAttachments,
                              style: AppStyle.textstylepoppinsregular12,
                            ),
                          SizedBox(height: 46.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnils(String path) {
    final extension = path.split('.').last.toLowerCase();
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: CircleAvatar(
        radius: 28.r,
        backgroundColor: AppColors.gray100,
        backgroundImage:
            (extension == 'jpg' || extension == 'jpeg' || extension == 'png')
                ? NetworkImage(AppStrings.baseUrl + path, scale: 5.0)
                : (extension == 'doc' || extension == 'docx')
                    ? const Icon(Icons.article) as ImageProvider
                    : (extension == 'pdf')
                        ? const Icon(Icons.picture_as_pdf) as ImageProvider
                        : (extension == 'zip')
                            ? const Icon(Icons.folder_zip) as ImageProvider
                            : const Icon(Icons.filter_none) as ImageProvider,
        child: const SizedBox(),
      ),
    );
  }

  List<Widget> _buildImagesGrid(BuildContext context,
      {required List<String> imagesPath, double? width, int imagesPerRow = 3}) {
    width ??= ScreenSize.width * 0.25;
    List<Widget> imagesGrid = [];
    for (int i = 0; i < imagesPath.length; i += imagesPerRow) {
      imagesGrid.add(
        Container(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int j = 0; j < imagesPerRow; j++)
                if (i + j < imagesPath.length)
                  Padding(
                    padding: EdgeInsets.only(left: j == 0 ? 0 : 8.w),
                    child: Stack(
                      children: [
                        _buildThumbnils(imagesPath[i + j]),
                        IconButton(
                          onPressed: () async {
                            // var random = Random();
                            String _downloadurl = imagesPath[i + j];
                            String filename = _downloadurl.split('/').last;
                            print(filename);

                            // String split = imagesPath[i + j].split("/").last;
                            // String rendomnmbr = split.split(".").last;

                            String? file = await Utils.downloadFile(
                              _downloadurl,
                              filename,
                              // rendomnmbr +
                              //     random.nextInt(10).toString() +
                              //     imagesPath[i + j]
                              //         .split('.')
                              //         .last
                              //         .toLowerCase(),
                              null,
                            );

                            final res = await Utils.openFile(file!);

                            if (res.message != "done") {
                              Utils.showToast(res.message);
                            }
                          },
                          icon: const SizedBox(),
                        )
                      ],
                    ),
                  ),
            ],
          ),
        ),
      );
    }
    return imagesGrid;
  }
}
