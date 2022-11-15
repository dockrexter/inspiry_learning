import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspiry_learning/models/message_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/manager/socket_manager.dart';
import 'package:inspiry_learning/models/assignment_model.dart';
import 'package:inspiry_learning/models/attachment_model.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/views/widgets/message_widget.dart';
import 'package:inspiry_learning/models/single_assaignment_model.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';
import 'package:inspiry_learning/repositories/assignment_repositories.dart';
import 'package:inspiry_learning/views/pages/admin/details/assignment_details_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    this.assignment,
    this.assaignmentid,
  }) : super(key: key);
  final String? assaignmentid;
  final Assignment? assignment;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isOnline = false;
  bool _isTyping = false;
  String _typingMsg = '';
  final List<Message> _messages = [];
  bool _isLoadingMessagesFromDB = true;
  final _isAdmin = UserTypeHelper.isAdmin();
  final _scrollController = ScrollController();
  final _messageController = TextEditingController();
  final allowedExtensions = ['jpg', 'png', 'jpeg', 'pdf', 'doc', 'docx', 'zip'];
  Assignment? assignment;
  AssignmentDetail? assignmentdetail;

  @override
  void initState() {
    super.initState();
    if (widget.assignment == null) {
      _getAssignmentsdetails();
    } else {
      assignment = widget.assignment;
      SocketManager().connect();
      SocketManager().joinRoom(
          userId: ActiveUser.instance.user!.userId!,
          assignmentId: assignment!.id);
    }

    SocketManager().onOnline(_handelOnline);
    SocketManager().onTyping(_handelTyping);
    SocketManager().onMessage(_handelMessage);
    SocketManager().onDBChat(_handelMessages);
    SocketManager().onMessageId(_handelMessageID);
    SocketManager().onPaymentUpdate(_handelPaymentUpdate);

    _messageController.addListener(() {
      if (_messageController.text.isNotEmpty) {
        SocketManager().emitTyping(
            {"typing": true, "message": ActiveUser.instance.user!.firstname});
        Future.delayed(const Duration(milliseconds: 3000), () {
          SocketManager().emitTyping({"typing": false, "message": ""});
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    SocketManager().emitTyping({"typing": false, "message": ""});
    SocketManager().disconnect();
    SocketManager().dispose();
    super.dispose();
  }

  Future<void> _getAssignmentsdetails() async {
    assignmentdetail = await AssignmentRepository()
        .getassignmentdetail(assaignmentId: widget.assaignmentid);
    assignment = Assignment(
        id: assignmentdetail!.id,
        assignTo: assignmentdetail!.assignTo,
        attachments: assignmentdetail!.attachments,
        createdDate: assignmentdetail!.createdDate,
        deadline: assignmentdetail!.deadline,
        status: assignmentdetail!.status,
        subject: assignmentdetail!.subject,
        summary: assignmentdetail!.summary,
        userId: assignmentdetail!.userId);
    SocketManager().connect();
    SocketManager().joinRoom(
        userId: ActiveUser.instance.user!.userId!,
        assignmentId: assignment!.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.h),
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
                    _isAdmin
                        ? AppStrings.chatWithUser
                        : AppStrings.chatWithProfessionals,
                    style: AppStyle.textstyleinterbold23.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
          if (assignment != null)
            Text(
              'Assignment: ${assignment?.subject}',
              style: AppStyle.textstylepoppinsregular14.copyWith(
                color: AppColors.white,
              ),
            ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (_isTyping && _isOnline) SizedBox(width: 4.w),
              Row(
                children: [
                  Text(
                    _isOnline ? AppStrings.online : AppStrings.offline,
                    style: AppStyle.textstyleinterbold23
                        .copyWith(color: AppColors.white, fontSize: 12.sp),
                  ),
                  SizedBox(width: 3.w),
                  Icon(
                    Icons.circle_rounded,
                    color: _isOnline ? Colors.green : Colors.red,
                    size: 7.w,
                  ),
                ],
              ),
              if (_isTyping && _isOnline)
                Text(
                  _typingMsg,
                  style: AppStyle.textstyleinterbold23
                      .copyWith(color: AppColors.white, fontSize: 12.sp),
                ),
              if (_isTyping && _isOnline) SizedBox(width: 4.w),
            ],
          ),
          SizedBox(height: 4.h),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                  left: 10.w, right: 10.w, top: 3.h, bottom: 6.h),
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
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(right: 16.w, left: 16.w, top: 10.h),
                    child: Row(
                      mainAxisAlignment: _isAdmin
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => AppRouter.push(
                            context,
                            AssignmentDetailsPage(assignment: assignment),
                          ),
                          child: Text(
                            AppStrings.assignmentDetails,
                            textAlign: TextAlign.center,
                            style: AppStyle.textstylepoppinssemibold14.copyWith(
                              color: AppColors.teal400,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        if (_isAdmin)
                          InkWell(
                            onTap: _showBottomQuatationSheet,
                            child: Text(
                              AppStrings.sendQuatation,
                              textAlign: TextAlign.center,
                              style:
                                  AppStyle.textstylepoppinssemibold14.copyWith(
                                color: AppColors.teal400,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (_isAdmin) Divider(color: AppColors.teal400, height: 12.h),
                  Expanded(
                    child: _isLoadingMessagesFromDB
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(
                              valueColor:
                                  AlwaysStoppedAnimation(AppColors.yellow701),
                            ),
                          )
                        : _messages.isEmpty
                            ? Center(
                                child: Text(
                                  AppStrings.sayHi,
                                  style: AppStyle.textstylepoppinsbold17,
                                ),
                              )
                            : SizedBox(
                                height: 1000,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  controller: _scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: _messages.length + 1,
                                  itemBuilder: (context, index) => index <
                                          _messages.length
                                      ? MessageWidget(message: _messages[index])
                                      : SizedBox(height: 20.h),
                                ),
                              ),
                  ),
                  SizedBox(height: 52.h),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: _buildFloatingActionButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _showBottomQuatationSheet() {
    SocketManager().emitTyping({"typing": false, "message": ""});
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();
    AppRouter.closeKeyboard(context);
    showModalBottomSheet(
      backgroundColor: AppColors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          top: 12.h,
          left: 16.w,
          right: 16.w,
          bottom: MediaQuery.of(context).viewInsets.bottom + 12.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 8.h),
            Text(
              AppStrings.priceQuatation,
              style: AppStyle.textstylepoppinssemibold12.copyWith(
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 20.h),
            InputTextField(
              AppStrings.price,
              controller: priceController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10.h),
            InputTextField(
              AppStrings.description,
              maxLines: 6,
              controller: descriptionController,
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: ScreenSize.width * 0.5,
              child: CustomButton(
                AppStrings.done,
                onPressed: () {
                  if (AppUtils.checkIsAnyFieldIsEmpty(controllers: [
                    priceController,
                    descriptionController,
                  ])) {
                    AppUtils.showToast(AppStrings.allFieldsAreRequired);
                    return;
                  }
                  if (priceController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty &&
                      int.parse(priceController.text) > 0) {
                    _sendMessage(
                      Message(
                        paymentStatus: 0,
                        type: MessageType.offer,
                        assignmentId: assignment!.id,
                        userId: ActiveUser.instance.user!.userId!,
                        paymentAmount: double.tryParse(priceController.text),
                        message:
                            "Title: ${widget.assignment!.subject} \nCharges: \$${priceController.text} \nDescription: ${descriptionController.text}",
                      ),
                    );
                    _messageController.clear();
                  }
                  AppRouter.pop(context);
                },
                color: AppColors.teal400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() => Container(
        height: 48.h,
        margin: EdgeInsets.symmetric(horizontal: 18.w),
        padding: EdgeInsets.only(left: 16.w, right: 10.w),
        decoration: BoxDecoration(
          color: AppColors.teal400,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () async => await _openCamera(),
              child: const Icon(
                Icons.camera_alt_outlined,
                size: 22,
                color: AppColors.teal100,
              ),
            ),
            Expanded(
              child: InputTextField(
                AppStrings.typeYourMessage,
                textColor: AppColors.white,
                controller: _messageController,
                cursorColor: AppColors.gray800,
              ),
            ),
            SizedBox(width: 2.w),
            InkWell(
              onTap: () => _openFilePicker(),
              child: Transform.rotate(
                angle: 0.2 * 3.14,
                child: const Icon(
                  Icons.attach_file_outlined,
                  size: 22,
                  color: AppColors.white,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            InkWell(
              onTap: () {
                if (_messageController.text.isNotEmpty) {
                  SocketManager().emitTyping({"typing": false, "message": ""});
                  _sendMessage(Message(
                    assignmentId: assignment!.id,
                    userId: ActiveUser.instance.user!.userId!,
                    message: _messageController.text,
                  ));
                  _messageController.clear();
                }
              },
              child: Container(
                width: 28.w,
                height: 25.h,
                padding: EdgeInsets.only(left: 4.w, bottom: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.teal100,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Transform.rotate(
                  angle: -0.23 * 3.14,
                  child: const Icon(
                    Icons.send_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Future<void> _openCamera() async {
    SocketManager().emitTyping({"typing": false, "message": ""});
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      _sendMessage(Message(
        type: MessageType.attachment,
        assignmentId: assignment!.id,
        userId: ActiveUser.instance.user!.userId!,
        attachment: Attachment.formFile(File(image.path)),
      ));
    }
  }

  Future<void> _openFilePicker() async {
    SocketManager().emitTyping({"typing": false, "message": ""});
    final result = await FilePicker.platform.pickFiles(
      withData: false,
      allowMultiple: true,
      withReadStream: false,
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    if (result != null) {
      for (var f in result.files) {
        _sendMessage(Message(
          type: MessageType.attachment,
          assignmentId: assignment!.id,
          userId: ActiveUser.instance.user!.userId!,
          attachment: Attachment.formPlatformFile(f),
        ));
      }
    }
  }

  void _sendMessage(Message message) {
    _messages.add(message);
    if (message.type != MessageType.attachment) {
      SocketManager().sendMessage(message.toJson());
    }
    setState(() {});
    _scrollToEnd();
  }

  void _handelOnline(data) {
    _isOnline = data as bool;
    setState(() {});
  }

  void _handelTyping(data) {
    _isTyping = data["typing"] as bool;
    _typingMsg = data["message"] as String;
    _typingMsg = _typingMsg + " is typing...";
    setState(() {});
  }

  void _handelPaymentUpdate(data) {
    if (data != null) {
      _messages.clear();
      for (var message in data) {
        final msg = Message.fromJson(message);
        msg.fromDB = true;
        _messages.add(msg);
      }
    }
    _isLoadingMessagesFromDB = false;
    setState(() {});
  }

  void _handelMessages(data) {
    if (data != null) {
      for (var message in data) {
        final msg = Message.fromJson(message);
        msg.fromDB = true;
        _messages.add(msg);
      }
    }
    _isLoadingMessagesFromDB = false;
    _scrollToEnd();
    setState(() {});
  }

  void _handelMessage(data) {
    _messages.add(Message.fromJson(data));
    setState(() {});
    _scrollToEnd();
  }

  void _handelMessageID(data) {
    _messages.last.id = data["id"];
    setState(() {});
  }

  void _scrollToEnd({bool updateState = true}) {
    Future.delayed(const Duration(seconds: 1), () async {
      if (_scrollController.hasClients) {
        // await _scrollController.animateTo(
        //   _scrollController.position.maxScrollExtent,
        //   duration: Duration(seconds: (_messages.length * 0.1).ceil()),
        //   curve: Curves.fastOutSlowIn,
        // );
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        if (updateState) setState(() {});
      }
    });
  }
}
