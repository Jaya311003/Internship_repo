import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship_project/feature/account/controller/account_controller.dart';
import 'package:internship_project/core/common/error_text.dart';
import 'package:internship_project/core/common/loader.dart';
import 'package:internship_project/core/constant/constants.dart';
import 'package:internship_project/core/utils.dart';
import 'package:internship_project/models/acccount_model.dart';
import 'package:internship_project/theme/pallet.dart';
import 'dart:io';

class EditAccountScreen extends ConsumerStatefulWidget {
  final String name;
  const EditAccountScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends ConsumerState<EditAccountScreen> {

  
  File? bannerFile;
  File? profileFile;
 

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
    
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      
        setState(() {
          profileFile = File(res.files.first.path!);
        });
      
    }
  }

  void save(Account account) {
    ref.read(accountControllerProvider.notifier).editAccount(
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
          account: account,
          
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(accountControllerProvider);
   

    return ref.watch(getAccountByNameProvider(widget.name)).when(
          data: (account) => Scaffold(
            backgroundColor: Pallet.whitecolor,
            appBar: AppBar(
              title: const Text('Edit Account'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => save(account),
                  child: const Text('Save'),
                ),
              ],
            ),
            body: isLoading
                ? const Loader()
                :  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: Stack(
                              children: [
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
                                      child:bannerFile != null
                                              ? Image.file(bannerFile!)
                                              : account.banner.isEmpty || account.banner == Constants.bannerDefault
                                                  ? const Center(
                                                      child: Icon(
                                                        Icons.camera_alt_outlined,
                                                        size: 40,
                                                      ),
                                                    )
                                                  : Image.network(account.banner),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  child: GestureDetector(
                                    onTap: selectProfileImage,
                                    child:  profileFile != null
                                            ? CircleAvatar(
                                                backgroundImage: FileImage(profileFile!),
                                                radius: 32,
                                              )
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(account.avatar),
                                                radius: 32,
                                              ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          
          loading: () => const Loader(),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
        );
  }
}
  
