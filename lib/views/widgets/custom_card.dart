import 'package:flutter/material.dart';
import 'package:inspiry_learning/globals/utils.dart';
import 'package:inspiry_learning/globals/colors.dart';
import 'package:inspiry_learning/globals/strings.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/assets_path.dart';
import 'package:inspiry_learning/models/assignment_model.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, required this.assignment, this.onPressed})
      : super(key: key);

  final VoidCallback? onPressed;
  final Assignment assignment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: AppColors.teal40065.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 4),
              color: AppColors.teal900.withOpacity(0.08),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  AppStrings.dueDate,
                  style: AppStyle.textstylepoppinsbold10t,
                ),
                const SizedBox(height: 3),
                Text(
                  assignment.dueDate!,
                  style: AppStyle.textstylepoppinsregular10,
                ),
                const Spacer(),
                Text(
                  AppStrings.startingDate,
                  style: AppStyle.textstylepoppinsbold10,
                ),
                const SizedBox(height: 3),
                Text(
                  assignment.startDate!,
                  style: AppStyle.textstylepoppinsregular10,
                ),
              ],
            ),
            const VerticalDivider(
              width: 26,
              thickness: 3,
              color: AppColors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    assignment.title!,
                    style: AppStyle.textstylepoppinssemibold14,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.52,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getStatus(assignment.workStatus),
                          style: AppStyle.textstylepoppinsmedium8,
                        ),
                        Icon(
                          assignment.workStatus == WorkStatus.compleated
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: AppColors.teal400,
                        ),
                        if (assignment.workStatus == WorkStatus.compleated)
                          GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                              AppAssets.askRevision,
                              scale: 4,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCard2 extends StatelessWidget {
  const CustomCard2({
    Key? key,
    this.onPressed,
    required this.assignment,
    required this.onSelected,
  }) : super(key: key);

  static final items = [
    'New Request',
    'Under Review',
    'Pending Payment',
    'Work in Progress',
    'Work Completed',
  ];

  final Function onSelected;
  final VoidCallback? onPressed;
  final Assignment assignment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(bottom: 20.0, left: 12, right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: AppColors.teal40065.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 4),
              color: AppColors.teal900.withOpacity(0.08),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  AppStrings.dueDate,
                  style: AppStyle.textstylepoppinsbold10t,
                ),
                const SizedBox(height: 3),
                Text(
                  assignment.dueDate!,
                  style: AppStyle.textstylepoppinsregular10,
                ),
                const Spacer(),
                Text(
                  AppStrings.startingDate,
                  style: AppStyle.textstylepoppinsbold10,
                ),
                const SizedBox(height: 3),
                Text(
                  assignment.startDate!,
                  style: AppStyle.textstylepoppinsregular10,
                ),
              ],
            ),
            const VerticalDivider(
              width: 26,
              thickness: 3,
              color: AppColors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          assignment.title!,
                          style: AppStyle.textstylepoppinssemibold14,
                        ),
                        Icon(
                          assignment.workStatus == WorkStatus.compleated
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: AppColors.teal400,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getStatus(assignment.workStatus),
                          style: AppStyle.textstylepoppinsmedium8,
                        ),
                        InkWell(
                          onTap: () => _showAlertDialog(context),
                          child: Container(
                            height: 20,
                            width: 55,
                            decoration: BoxDecoration(
                              color: AppColors.yellow701,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                AppStrings.status + AppStrings.triangleDown,
                                style: AppStyle.textstylepoppinssemibold10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: 30,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items
                .map((e) => Column(
                      children: [
                        InkWell(
                            child: Text(e),
                            onTap: () {
                              onSelected(e);
                              Navigator.pop(context);
                            }),
                        const Divider(),
                      ],
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}
