import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/models/assignment_model.dart';
import 'package:inspiry_learning/models/attachment_model.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';
import 'package:inspiry_learning/repositories/assignment_repositories.dart';

class AssignmentFormSubmissionPage extends StatefulWidget {
  const AssignmentFormSubmissionPage({Key? key}) : super(key: key);

  @override
  State<AssignmentFormSubmissionPage> createState() =>
      _AssignmentFormSubmissionPageState();
}

class _AssignmentFormSubmissionPageState
    extends State<AssignmentFormSubmissionPage> {
  bool _isLoading = false;
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  final List<PlatformFile> _files = [];
  final _subjectController = TextEditingController();
  final _summaryController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SizedBox(
          height: ScreenSize.height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SafeArea(
                  child: Row(
                    children: [
                      SizedBox(width: 3.w),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: AppColors.black,
                        ),
                        onPressed: () => AppRouter.pop(context),
                      ),
                      const Spacer(),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 14.h),
                          child: Image.asset(
                            AppAssets.girlWithLaptop,
                            scale: 2.8,
                          ),
                        ),
                      ),
                      const Spacer(flex: 3),
                    ],
                  ),
                ),
                Text(
                  AppStrings.assignmentSubmissionForm,
                  style: AppStyle.textstylepoppinsbold20,
                ),
                Text(
                  AppStrings.contactedTime,
                  textAlign: TextAlign.center,
                  style: AppStyle.textstylepoppinsregular14,
                ),
                InkWell(
                  onTap: () => AppRouter.pop(context),
                  child: Text(
                    AppStrings.viewAllForms,
                    textAlign: TextAlign.center,
                    style: AppStyle.textstylepoppinsbold9.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                InputTextField(
                  AppStrings.subject,
                  controller: _subjectController,
                ),
                InputTextField(
                  maxLines: 6,
                  AppStrings.summary,
                  controller: _summaryController,
                ),
                Row(
                  children: [
                    Image.asset(
                      AppAssets.calanderIcon,
                      scale: 5,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      AppStrings.dueDate,
                      textAlign: TextAlign.center,
                      style: AppStyle.textstylepoppinssemibold12,
                    ),
                    const Spacer(),
                    _buildPickers(1),
                    SizedBox(width: 10.w),
                    _buildPickers(2),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppStrings.attachments,
                    style: AppStyle.textstylepoppinssemibold14,
                  ),
                ),
                GestureDetector(
                  onTap: () async => await _openFilePicker(),
                  child: Image.asset(
                    AppAssets.addFiles,
                    scale: 4,
                  ),
                ),
                SizedBox(height: 8.h),
                showFiles(files: _files),
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: _isLoading
                      ? const CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.yellow701,
                          ),
                        )
                      : CustomButton(
                          AppStrings.submitAndProceed,
                          onPressed: () async => await _submitAndProceed(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitAndProceed() async {
    if (_subjectController.text.isEmpty) {
      AppUtils.showToast(AppStrings.subjectRequired);
      return;
    }
    setState(() => _isLoading = true);
    final assignment = Assignment(
      id: -1,
      subject: _subjectController.text,
      summary: _summaryController.text,
      status: WorkStatus.newRequest,
      userId: ActiveUser.instance.user?.userId,
      attachments: _files.map((file) => Attachment.formPlatformFile(file)).toList(),
      deadline: DateTime(
        _date.year,
        _date.month,
        _date.day,
        _time.hour,
        _time.minute,
      ),
    );
    final result = await AssignmentRepository().createAssignment(assignment);
    setState(() => _isLoading = false);
    if (result) {
      _buildDialog(context);
    } else {
      AppUtils.showToast(AppStrings.somethingWentWrong);
    }
  }

  Future<dynamic> _buildDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.r),
          ),
        ),
        contentPadding: const EdgeInsets.all(0.0),
        content: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20.h),
              Image.asset(
                AppAssets.thumbsUp,
                scale: 4,
              ),
              SizedBox(height: 20.h),
              const Icon(
                Icons.star,
                color: AppColors.orange800,
              ),
              SizedBox(height: 10.h),
              Text(
                AppStrings.thankyou,
                style: AppStyle.textstylepoppinssemibold12.copyWith(
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                AppStrings.contactedTime,
                style: AppStyle.textstylepoppinsregular10,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            child: Text(
              AppStrings.done,
              style: AppStyle.textstylepoppinssemibold12,
            ),
            onPressed: () {
              AppRouter.pop(context);
              AppRouter.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget showFiles({required List<PlatformFile> files}) {
    return SizedBox(
      height: 80.h,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          return _buildFile(file);
        },
      ),
    );
  }

  Widget _buildFile(PlatformFile file) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: CircleAvatar(
        backgroundColor: AppColors.gray100,
        backgroundImage: (file.extension == 'jpg' || file.extension == 'png')
            ? FileImage(File(file.path.toString()), scale: 5.0)
            : const AssetImage(AppAssets.imageNotFound) as ImageProvider,
        child: Stack(
          children: [
            Positioned(
              top: 12.h,
              right: 0,
              child: InkWell(
                onTap: () {
                  _files.remove(file);
                  setState(() {});
                },
                child: CircleAvatar(
                  radius: 10.r,
                  backgroundColor: AppColors.gray100,
                  child: Icon(
                    Icons.close,
                    size: 12.w,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openFilePicker() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
      withReadStream: true,
    );
    if (result == null) return;
    for (final file in result.files) {
      _files.add(file);
    }
    setState(() {});
  }

  Future<void> _openTimePicker() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    _time = time ?? _time;
    setState(() {});
  }

  Future<void> _openDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    _date = date ?? _date;
    setState(() {});
  }

  Widget _buildPickers(int index) {
    return GestureDetector(
      onTap: () async =>
          await (index == 1 ? _openDatePicker() : _openTimePicker()),
      child: Container(
        width: 80,
        height: 25,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.teal40065, width: 2.w),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            index == 1
                ? const DefaultMaterialLocalizations().formatShortDate(_date)
                : _time.format(context),
            style: AppStyle.textstylepoppinssemibold10,
          ),
        ),
      ),
    );
  }
}
