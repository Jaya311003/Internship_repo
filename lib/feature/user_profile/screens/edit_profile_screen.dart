import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:internship_project/feature/account/controller/account_controller.dart';
import 'package:internship_project/core/common/error_text.dart';
import 'package:internship_project/core/common/loader.dart';
import 'package:internship_project/core/constant/constants.dart';
import 'package:internship_project/core/utils.dart';
import 'package:internship_project/feature/auth/controller/auth_controller.dart';
import 'package:internship_project/feature/user_profile/controller/user_profile_controller.dart';
//import 'package:internship_project/models/acccount_model.dart';
import 'package:internship_project/theme/pallet.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }
 
 @override
 void dispose(){
  super.dispose();
  nameController.dispose();
 }

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

  void save() {
    ref.read(UserProfileControllerProvider.notifier).editAccount(
          profileFile: profileFile,
          bannerFile: bannerFile,
          context: context,
          name: nameController.text.trim(),
          
        );
  }


  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(UserProfileControllerProvider);
   // final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getUserDataProvider(widget.uid)).when(
          data: (user) => Scaffold(
            backgroundColor: Pallet.whitecolor,
            appBar: AppBar(
              title: const Text('Edit Profie'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed:  save,
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
                                              : user.banner.isEmpty || user.banner == Constants.bannerDefault
                                                  ? const Center(
                                                      child: Icon(
                                                        Icons.camera_alt_outlined,
                                                        size: 40,
                                                      ),
                                                    )
                                                  : Image.network(user.banner),
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
                                                backgroundImage: NetworkImage(user.profilePic),
                                                radius: 32,
                                              ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              filled: true,
                              hintText: 'Name',
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(18),
                            ),
                          )
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