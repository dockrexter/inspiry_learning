import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/app_router.dart';
import 'package:inspiry_learning/globals/app_assets.dart';
import 'package:inspiry_learning/globals/app_colors.dart';
import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';

class AssignmentFormSubmissionPage extends StatefulWidget {
  const AssignmentFormSubmissionPage({Key? key}) : super(key: key);

  @override
  State<AssignmentFormSubmissionPage> createState() =>
      _AssignmentFormSubmissionPageState();
}

class _AssignmentFormSubmissionPageState
    extends State<AssignmentFormSubmissionPage> {
  // ignore: unused_field
  String _filePath = '';
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  final _subjectController = TextEditingController();
  final _summaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
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
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: CustomButton(
                    AppStrings.submitAndProceed,
                    onPressed: () => _buildDialog(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  Future<void> _openFilePicker() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      _filePath = result.files.first.path!;
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
      firstDate: DateTime(DateTime.now().year),
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
        width: 72,
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
