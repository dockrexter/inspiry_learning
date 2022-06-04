import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:inspiry_learning/globals/colors.dart';
import 'package:inspiry_learning/globals/strings.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/assets_path.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Image.asset(
                        AppAssets.girlWithLaptop,
                        scale: 2.8,
                      ),
                    ),
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
                Text(
                  AppStrings.viewAllForms,
                  textAlign: TextAlign.center,
                  style: AppStyle.textstylepoppinsbold9.copyWith(
                    decoration: TextDecoration.underline,
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
                    const SizedBox(width: 10),
                    Text(
                      AppStrings.dueDate,
                      textAlign: TextAlign.center,
                      style: AppStyle.textstylepoppinssemibold12,
                    ),
                    const Spacer(),
                    _buildPickers(1),
                    const SizedBox(width: 10),
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
                    scale: 5,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        contentPadding: const EdgeInsets.all(0.0),
        content: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                AppAssets.thumbsUp,
                scale: 4,
              ),
              const SizedBox(height: 20),
              const Icon(
                Icons.star,
                color: AppColors.orange800,
              ),
              const SizedBox(height: 10),
              Text(
                AppStrings.thankyou,
                style: AppStyle.textstylepoppinssemibold12.copyWith(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppStrings.contactedTime,
                style: AppStyle.textstylepoppinsregular8,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
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
          border: Border.all(color: AppColors.teal40065, width: 2),
          borderRadius: BorderRadius.circular(12.0),
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
