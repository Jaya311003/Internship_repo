import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship_project/feature/account/controller/account_controller.dart';
import 'package:internship_project/core/common/loader.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  final accountNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    accountNameController.dispose();
  }

  void createAccount() {
    ref.read(accountControllerProvider.notifier).createAccount(
          accountNameController.text.trim(),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(accountControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create an account'),
        centerTitle: true,
      ),
      body: isLoading? const Loader(): Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text('Username'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: accountNameController,
              decoration: const InputDecoration(
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                contentPadding: EdgeInsets.all(15),
              ),
              maxLength: 30,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: createAccount,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
              child: const Text('Create an account'),
            )
          ],
        ),
      ),
    );
  }
}
