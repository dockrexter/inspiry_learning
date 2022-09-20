import "package:flutter/cupertino.dart";
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/models/all_notification_read_model.dart';
import 'package:inspiry_learning/models/single_notification_read_model.dart';
import 'package:inspiry_learning/repositories/allnotification_repo.dart';
import 'package:inspiry_learning/views/pages/common/chat/chat_page.dart';

class CustomNotification extends StatelessWidget {
  const CustomNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

void customNotificationsPopup(BuildContext context, {List? allnotification}) {
  final Box _countBox = Hive.box('notificationcounter');
  int count = _countBox.get('count', defaultValue: 0);
  int isreadlenght = 0;
  for (var i = 0; i < allnotification!.length; i++) {
    if (allnotification[i].isRead == false) {
      isreadlenght++;
      print(isreadlenght);
    }
  }
  Future<void> _singlenotificationread(String? selectednotification) async {
    SingleNotificationRead? _singlenotify;

    print(selectednotification);
    _singlenotify = await AllNotifactionRepository()
        .singlenotificationread(selectednotification);
  }

  Future<void> _allnotificationread(String? userId) async {
    AllNotificationRead? _allnotifyread;

    print(userId);
    _allnotifyread =
        await AllNotifactionRepository().allnotificationread(userId);
  }

  showCupertinoDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => SafeArea(
      child: AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              isreadlenght.toString() == "0"
                  ? "You have $isreadlenght unread Notifications"
                  : "You have $isreadlenght unread Notifications",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.black900,
              ),
            ),
            IconButton(
                onPressed: () async {
                  print(ActiveUser.instance.user!.userId!.toString());
                  _allnotificationread(
                      ActiveUser.instance.user!.userId!.toString());
                },
                icon: const Icon(
                  Icons.check,
                  color: AppColors.greenA700,
                ))
          ],
        ),
        insetPadding: EdgeInsets.only(bottom: 56.h, right: 64.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
        ),
        contentPadding: const EdgeInsets.all(0.0),
        content: Builder(builder: (context) {
          return Container(
            width: ScreenSize.width * 0.7,
            height: ScreenSize.height * 0.7,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
            ),
            child: allnotification == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "New",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black900,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),

                      isreadlenght == 0
                          ? Container()
                          : Expanded(
                              child: ListView.builder(
                                itemCount: allnotification.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    allnotification[index].isRead
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              _singlenotificationread(
                                                      allnotification[index]
                                                          .id
                                                          .toString())
                                                  .whenComplete(() => {
                                                        allnotification
                                                            .removeAt(index),
                                                        _countBox.put(
                                                            'count', --count),
                                                        AppRouter.push(
                                                            context,
                                                            ChatPage(
                                                              assaignmentid:
                                                                  allnotification[
                                                                          index]
                                                                      .assignmentID,
                                                            )),
                                                      });
                                            },
                                            child: Container(
                                              height: 85.h,
                                              margin: EdgeInsets.only(
                                                  bottom: 16.h,
                                                  left: 10.h,
                                                  right: 10.h),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 8.h),
                                              decoration: BoxDecoration(
                                                color: AppColors.teal40065
                                                    .withOpacity(0.12),
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 12.r,
                                                    offset: const Offset(0, 4),
                                                    color: AppColors.teal900
                                                        .withOpacity(0.08),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.notifications,
                                                    color: AppColors.teal900,
                                                    size: 24.w,
                                                  ),
                                                  SizedBox(width: 16.w),
                                                  Expanded(
                                                    child: Text(
                                                      allnotification[index]
                                                              .title +
                                                          allnotification[index]
                                                              .message,
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            AppColors.teal900,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                              ),
                            ),
                      //Seen\\

                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Seen",
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black900,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Expanded(
                        child: ListView.builder(
                          itemCount: allnotification.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                AppRouter.push(
                                    context,
                                    ChatPage(
                                      assaignmentid:
                                          allnotification[index].assignmentID,
                                    ));
                              },
                              child: allnotification[index].isRead
                                  ? Container(
                                      height: 85.h,
                                      margin: EdgeInsets.only(
                                          bottom: 16.h,
                                          left: 10.h,
                                          right: 10.h),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 8.h),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                                98, 203, 222, 216)
                                            .withOpacity(0.12),
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 12.r,
                                            offset: const Offset(0, 4),
                                            color: AppColors.teal900
                                                .withOpacity(0.08),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.notifications,
                                            color: AppColors.teal900,
                                            size: 24.w,
                                          ),
                                          SizedBox(width: 16.w),
                                          Expanded(
                                            child: Text(
                                              allnotification[index].title +
                                                  allnotification[index]
                                                      .message,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.teal900,
                                              ),
                                            ),
                                          ),
                                          // Text(
                                          //   allnotification[index].message,
                                          //   style: TextStyle(
                                          //     fontSize: 12.sp,
                                          //     fontWeight: FontWeight.w500,
                                          //     color: AppColors.teal900,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    )
                                  : Container()),
                        ),
                      ),
                    ],
                  ),
          );
        }),
      ),
    ),
  );
}
