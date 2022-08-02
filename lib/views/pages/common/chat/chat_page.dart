import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:inspiry_learning/models/message_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';
import 'package:inspiry_learning/models/assignment_model.dart';
import 'package:inspiry_learning/models/attachment_model.dart';
import 'package:inspiry_learning/providers/chat_provider.dart';
import 'package:inspiry_learning/views/widgets/custom_button.dart';
import 'package:inspiry_learning/views/widgets/message_widget.dart';
import 'package:inspiry_learning/views/widgets/custom_text_field.dart';
import 'package:inspiry_learning/views/pages/common/camera/camera_page.dart';
import 'package:inspiry_learning/views/pages/admin/details/assignment_details_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.assignment}) : super(key: key);

  final Assignment assignment;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatProvider _chatProvider;
  late List<Message> filteredMessages;
  final _scrollController = ScrollController();
  final bool _isAdmin = UserTypeHelper.isAdmin();
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToEnd(updateState: false));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    _chatProvider.disconnect();
    super.dispose();
  }

  void _scrollToEnd({bool updateState = true}) {
    if (_scrollController.hasClients) {
      _scrollController
          .jumpTo(_scrollController.position.maxScrollExtent + 10.0);
      if (updateState) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _chatProvider = Provider.of<ChatProvider>(context);
    filteredMessages = _chatProvider.messages
        .where((msg) => msg.assignmentId == widget.assignment.id)
        .toList();
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
                  if (_isAdmin)
                    Padding(
                      padding:
                          EdgeInsets.only(right: 16.w, left: 16.w, top: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => AppRouter.push(
                              context,
                              AssignmentDetailsPage(
                                  assignment: widget.assignment),
                            ),
                            child: Text(
                              AppStrings.assignmentDetails,
                              textAlign: TextAlign.center,
                              style:
                                  AppStyle.textstylepoppinssemibold14.copyWith(
                                color: AppColors.teal400,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
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
                    child: filteredMessages.isEmpty
                        ? Center(
                            child: Text("Say hi!",
                                style: AppStyle.textstylepoppinsbold17))
                        : ListView.builder(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(),
                            itemCount: filteredMessages.length + 1,
                            itemBuilder: (context, index) =>
                                index < filteredMessages.length
                                    ? MessageWidget(
                                        message: filteredMessages[index])
                                    : SizedBox(height: 20.h),
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
                  if (priceController.text.isNotEmpty &&
                      descriptionController.text.isNotEmpty) {
                    _chatProvider.sendMessage(
                      Message(
                        id: 1,
                        assignmentId: widget.assignment.id,
                        isMe: true,
                        paymentAmount: double.tryParse(priceController.text),
                        message:
                            "Price: ${priceController.text}\nDescription: ${descriptionController.text}",
                      ),
                    );
                    _scrollToEnd();
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
                  _chatProvider.sendMessage(Message(
                      id: 1,
                      assignmentId: widget.assignment.id,
                      isMe: true,
                      message: _messageController.text));
                  _scrollToEnd();
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
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    AppRouter.push(context,
        CameraPage(camera: firstCamera, assignmentId: widget.assignment.id));
  }

  Future<void> _openFilePicker() async {
    final result = await FilePicker.platform.pickFiles(
      withData: false,
      allowMultiple: true,
      withReadStream: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf', 'doc', 'docx', 'zip'],
    );
    if (result != null) {
      for (var f in result.files) {
        _chatProvider.sendMessage(Message(
          id: 1,
          isMe: true,
          assignmentId: widget.assignment.id,
          attachment: Attachment.formPlatformFile(f),
        ));
      }
    }
    setState(() {});
    _scrollToEnd();
  }
}
