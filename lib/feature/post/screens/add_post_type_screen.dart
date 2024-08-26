import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship_project/feature/account/controller/account_controller.dart';
import 'package:internship_project/core/common/error_text.dart';
import 'package:internship_project/core/common/loader.dart';
import 'package:internship_project/core/utils.dart';
import 'package:internship_project/feature/post/controller/post_controller.dart';
import 'package:internship_project/models/acccount_model.dart';
import 'package:internship_project/theme/pallet.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final discriptionController = TextEditingController();
  final linkController = TextEditingController();
  File? bannerFile;
  Account? selectedAccount;

  List<Account> accounts = [];

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    discriptionController.dispose();
    linkController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        bannerFile != null &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
            context: context,
            title: titleController.text.trim(),
            selectedAccount: selectedAccount ?? accounts[0],
            file: bannerFile,
          );
    } else if (widget.type == 'text' && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: titleController.text.trim(),
            selectedAccount: selectedAccount ?? accounts[0],
            description: discriptionController.text.trim(),
          );
    } else if (widget.type == 'link' &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
            context: context,
            title: titleController.text.trim(),
            selectedAccount: selectedAccount ?? accounts[0],
            link: linkController.text.trim(),
          );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final isLoading = ref.watch(postControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: [TextButton(onPressed: sharePost, child: const Text('Share'))],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter Title here',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (isTypeImage)
                    GestureDetector(
                      onTap: selectBannerImage,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        color: Pallet.blackColor,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: bannerFile != null
                              ? Image.file(bannerFile!)
                              : const Center(
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 40,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  if (isTypeText)
                    TextField(
                      controller: discriptionController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter discription here',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                    ),
                  if (isTypeLink)
                    TextField(
                      controller: linkController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Enter Link here',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Select Account'),
                  ),
                  ref.watch(userAccountProvider).when(
                        data: (data) {
                          accounts = data;
                          if (data.isEmpty) {
                            return const SizedBox();
                          }
                          return DropdownButton(
                              value: selectedAccount ?? data[0],
                              items: data
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: ((val) {
                                setState(() {
                                  selectedAccount = val;
                                });
                              }));
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      ),
                ],
              ),
            ),
    );
  }
}
