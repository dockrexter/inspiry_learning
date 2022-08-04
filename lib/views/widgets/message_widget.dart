import 'package:flutter/material.dart';
import 'package:inspiry_learning/globals/app_style.dart';
import 'package:inspiry_learning/globals/app_utils.dart';
import 'package:inspiry_learning/globals/app_colors.dart';
import 'package:inspiry_learning/globals/app_strings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/models/message_model.dart';
import 'package:inspiry_learning/manager/socket_manager.dart';
import 'package:inspiry_learning/repositories/payment_repositories.dart';

class MessageWidget extends StatefulWidget {
  final Message message;

  const MessageWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  bool isError = false;

  @override
  void initState() {
    super.initState();
    widget.message.isMe ? _uploadFile() : _downloadFile();
  }

  void _uploadFile() async {
    // if (widget.message.attachment != null) {
    //   if (await widget.message.attachment!.upload()) {
    //     SocketManager().sendMessage(widget.message.toJson());
    //   } else {
    //     isError = true;
    //   }
    //   if (mounted){
    //     setState(() {});
    //   }
    // }
  }

  void _downloadFile() async {
    // if (widget.message.attachment != null) {
    //   if (!await widget.message.attachment!.download()) {
    //     isError = true;
    //     setState(() {});
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.message.message != null
          ? null
          : () async {
              if (widget.message.attachment!.path != null) {
                final res =
                    await Utils.openFile(widget.message.attachment!.path!);
                if (res.message != "done") {
                  Utils.showToast(res.message);
                }
              }
            },
      child: Row(
        mainAxisAlignment: widget.message.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(widget.message.message == null ? 10 : 16),
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
              Text(
                widget.message.message!,
                style: AppStyle.textstylepoppinsmedium12.copyWith(
                  color: AppColors.gray80099,
                ),
              ),
              if (widget.message.type.index == 1) SizedBox(height: 12.h),
              if (widget.message.type.index == 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!widget.message.isMe)
                      _buildCustomButtons(
                        text: AppStrings.pay,
                        color: AppColors.primary,
                        icon: Icons.send,
                        onTap: () async {
                          final url = await PaymentRepository().payWithPapal(
                              amount: widget.message.paymentAmount!);
                          if (url != null) {
                            await Utils.launchURL(url);
                          }
                        },
                      ),
                    _buildCustomButtons(
                      text: AppStrings.reject,
                      color: AppColors.red300,
                      onTap: () async => await Utils.launchURL(
                          "https://github.com/Usama-Azad"),
                    ),
                  ],
                ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                constraints: const BoxConstraints(maxWidth: 240),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: Colors.transparent.withOpacity(0.04),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          widget.message.attachment!.name.length > 16
                              ? widget.message.attachment!.name
                                      .substring(0, 16) +
                                  '...'
                              : widget.message.attachment!.name,
                          style: AppStyle.textstylepoppinsregular14.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    if (!widget.message.attachment!.isUploaded)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            widget.message.isMe
                                ? Icons.upload_rounded
                                : Icons.download_rounded,
                            size: 18.sp,
                            color: AppColors.gray600,
                          ),
                          CircularProgressIndicator(
                            strokeWidth: 2.w,
                            valueColor:
                                const AlwaysStoppedAnimation(AppColors.gray600),
                            backgroundColor: AppColors.gray100,
                          ),
                        ],
                      ),
                    if (!widget.message.attachment!.isUploaded)
                      _buildUploadDownloadButtons(onPressed: () {
                        isError = false;
                        setState(() {});
                        _uploadFile();
                      }),
                    if (widget.message.attachment!.path == null && !widget.message.isMe)
                      _buildUploadDownloadButtons(onPressed: () {
                        isError = false;
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
                    Utils.converBytes(widget.message.attachment!.size) +
                        " . " +
                        widget.message.attachment!.extension!.toUpperCase(),
                    style: AppStyle.textstylepoppinsmedium12.copyWith(
                      color: AppColors.gray80099,
                    ),
                  ),
                  if (widget.message.timeStamp != null)
                    Text(
                      Utils.fromatTime(widget.message.timeStamp!),
                      style: AppStyle.textstylepoppinsmedium12.copyWith(
                        color: AppColors.gray80099,
                      ),
                    ),
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
          onPressed: isError ? onPressed : null,
          icon: Icon(
            widget.message.isMe ? Icons.upload_rounded : Icons.download_rounded,
            size: 18.sp,
            color: AppColors.gray600,
          ),
        ),
        CircularProgressIndicator(
          value: isError ? 0.3 : null,
          strokeWidth: 2.w,
          valueColor: const AlwaysStoppedAnimation( AppColors.gray800),
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
