import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:inspiry_learning/models/message_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/manager/socket_manager.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/repositories/payment_repositories.dart';

class MessageWidget extends StatefulWidget {
  final Message message;

  const MessageWidget({
    super.key,
    required this.message,
  });

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  bool _isError = false;
  bool _showDownLoadButton = false;

  @override
  void initState() {
    super.initState();
    if (!widget.message.fromDB) {
      if (widget.message.isMe) {
        _uploadFile();
      }
    }
  }

  Future<void> _uploadFile() async {
    if (widget.message.attachment != null) {
      if (await widget.message.attachment!.upload()) {
        SocketManager().sendMessage(widget.message.toJson());
      } else {
        _isError = true;
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _downloadFile() async {
    if (widget.message.attachment != null) {
      if (!await widget.message.attachment!.download()) {
        _isError = true;
      } else {
        _showDownLoadButton = false;
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.message.message != null
          ? null
          : () async {
              if (!await widget.message.attachment!
                  .resolvePath(widget.message.isMe)) {
                if (widget.message.attachment!.isUploaded) {
                  _showDownLoadButton = true;
                  if (mounted) {
                    setState(() {});
                  }
                  await _downloadFile();
                }
              }
              if (widget.message.attachment!.path != null) {
                String path = widget.message.attachment!.path!;
                final res = await AppUtils.openFile(path);

                if (res.message != "done") {
                  AppUtils.showToast(res.message);
                }
              }
            },
      child: Row(
        mainAxisAlignment: widget.message.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(widget.message.message == null ? 10 : 12),
            margin: const EdgeInsets.all(16),
            constraints: const BoxConstraints(maxWidth: 250),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: widget.message.isMe ? AppColors.teal100 : AppColors.white,
            ),
            child: buildMessage(),
          ),
        ],
      ),
    );
  }

  Widget buildMessage() {
    return widget.message.message != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!widget.message.isMe)
                    Row(
                      children: [
                        Text(
                          '${widget.message.userName}',
                          style: AppStyle.textstylepoppinsmedium10.copyWith(
                            color: AppColors.greenA700.withOpacity(0.5),
                          ),
                        ),
                        Text(
                          '(',
                          style: AppStyle.textstylepoppinsmedium10.copyWith(
                            color: AppColors.black.withOpacity(0.4),
                          ),
                        ),
                        Text(
                          '${widget.message.userRole}',
                          style: AppStyle.textstylepoppinsmedium10.copyWith(
                            color: AppColors.greenA700.withOpacity(0.5),
                          ),
                        ),
                        Text(
                          ')',
                          style: AppStyle.textstylepoppinsmedium10.copyWith(
                            color: AppColors.black.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 10.h),
                  Text(
                    widget.message.type == MessageType.offer
                        ? "Charges: \$${widget.message.paymentAmount} \nDescription: ${widget.message.message}"
                        : widget.message.message!,
                    style: AppStyle.textstylepoppinsmedium14.copyWith(
                      color: AppColors.black90087,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.message.timeStamp != null)
                        Text(
                          AppUtils.fromatTime(widget.message.timeStamp!),
                          style: AppStyle.textstylepoppinsmedium10.copyWith(
                            color: AppColors.black90075,
                          ),
                        ),
                      if (widget.message.isMe) SizedBox(width: 4.w),
                      if (widget.message.isMe)
                        const Icon(Icons.check,
                            color: AppColors.black90075, size: 14),
                    ],
                  ),
                ],
              ),
              if (widget.message.type.index == 1) SizedBox(height: 12.h),
              if (widget.message.type.index == 1)
                widget.message.paymentStatus == 2
                    ? const Text("Rejected",
                        style: TextStyle(color: AppColors.red300))
                    : widget.message.paymentStatus == 1
                        ? const Text("Paid",
                            style: TextStyle(color: AppColors.primary))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if ((!widget.message.isMe) &&
                                  UserTypeHelper.isUser())
                                _buildCustomButtons(
                                  text: AppStrings.pay,
                                  color: AppColors.primary,
                                  icon: Icons.send,
                                  onTap: () async {
                                    AppUtils.showToast(
                                        AppStrings.initialingPaymentProcess);
                                    final url = await PaymentRepository()
                                        .payWithPapal(
                                            messageId: widget.message.id!,
                                            assignmentId:
                                                widget.message.assignmentId,
                                            itemName: "Payment for Assignment",
                                            description:
                                                widget.message.message!,
                                            amount:
                                                widget.message.paymentAmount!);
                                    if (url != null) {
                                      widget.message.paymentStatus = 1;
                                      await AppUtils.launchURL(url);
                                    }
                                    SocketManager().sendPaymentStatus();
                                    setState(() {});
                                  },
                                ),
                              _buildCustomButtons(
                                text: AppStrings.reject,
                                color: AppColors.red300,
                                onTap: () async => await showDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                    title: const Text("Reject Payment"),
                                    content: const Text(
                                        "Please Confirm Payment Rejection"),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: const Text("Yes"),
                                        onPressed: () async {
                                          if (widget.message.id != null) {
                                            await PaymentRepository()
                                                .rejectPayment(
                                                    messageId:
                                                        widget.message.id!);
                                            widget.message.paymentStatus = 2;
                                            setState(() {});
                                          }
                                          SocketManager().sendPaymentStatus();
                                          AppRouter.pop(context);
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        child: const Text("No"),
                                        onPressed: () => AppRouter.pop(context),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (!widget.message.isMe && UserTypeHelper.isAdmin())
                Row(
                  children: [
                    Text(
                      '${widget.message.userName}',
                      style: AppStyle.textstylepoppinsmedium10.copyWith(
                        color: AppColors.greenA700.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      '(',
                      style: AppStyle.textstylepoppinsmedium10.copyWith(
                        color: AppColors.black.withOpacity(0.4),
                      ),
                    ),
                    Text(
                      '${widget.message.userRole}',
                      style: AppStyle.textstylepoppinsmedium10.copyWith(
                        color: AppColors.greenA700.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      ')',
                      style: AppStyle.textstylepoppinsmedium10.copyWith(
                        color: AppColors.black.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 10.h),
              Container(
                padding: const EdgeInsets.all(12),
                constraints: const BoxConstraints(maxWidth: 240),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: Colors.transparent.withOpacity(0.04),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.file_copy_sharp,
                          size: 18.sp,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          widget.message.attachment!.name.length > 14
                              ? widget.message.attachment!.name
                                      .substring(0, 14) +
                                  '...'
                              : widget.message.attachment!.name,
                          style: AppStyle.textstylepoppinsregular14.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    if (!widget.message.attachment!.isUploaded)
                      _buildUploadDownloadButtons(onPressed: () {
                        _isError = false;
                        setState(() {});
                        _uploadFile();
                      }),
                    if (_showDownLoadButton)
                      _buildUploadDownloadButtons(onPressed: () {
                        _isError = false;
                        setState(() {});
                        _downloadFile();
                      })
                  ],
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppUtils.converBytes(widget.message.attachment!.size) +
                        " . " +
                        widget.message.attachment!.extension!.toUpperCase(),
                    style: AppStyle.textstylepoppinsmedium12.copyWith(
                      color: AppColors.gray80099,
                    ),
                  ),
                  Row(
                    children: [
                      if (widget.message.timeStamp != null)
                        Text(
                          AppUtils.fromatTime(widget.message.timeStamp!),
                          style: AppStyle.textstylepoppinsmedium12.copyWith(
                            color: AppColors.gray80099,
                          ),
                        ),
                      if (widget.message.isMe) SizedBox(width: 4.w),
                      if (widget.message.isMe)
                        const Icon(Icons.check,
                            color: AppColors.black90075, size: 15),
                    ],
                  )
                ],
              ),
            ],
          );
  }

  Widget _buildUploadDownloadButtons({void Function()? onPressed}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: _isError ? onPressed : null,
          icon: Icon(
            (widget.message.isMe && !_showDownLoadButton)
                ? Icons.upload_rounded
                : Icons.download_rounded,
            size: 18.sp,
            color: AppColors.gray600,
          ),
        ),
        CircularProgressIndicator(
          value: _isError ? 0 : null,
          strokeWidth: 2.w,
          valueColor: const AlwaysStoppedAnimation(AppColors.gray800),
          backgroundColor: AppColors.gray100,
        ),
      ],
    );
  }

  Widget _buildCustomButtons({
    IconData? icon,
    required String text,
    required Color color,
    void Function()? onTap,
  }) {
    final textWidget = Text(
      text,
      style: AppStyle.textstylepoppinsregular14.copyWith(
        color: AppColors.white,
      ),
    );
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Center(
          child: icon == null
              ? textWidget
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    textWidget,
                    Transform.rotate(
                      angle: -0.23 * 3.14,
                      child: Icon(
                        icon,
                        size: 15,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
