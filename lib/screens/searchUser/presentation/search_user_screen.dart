import 'dart:convert';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:skyislimit/rest/hive_repo.dart';
import 'package:skyislimit/routes/app_router.gr.dart';
import 'package:skyislimit/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../../widgets/login_button.dart';
import '../data/search_user_provider.dart';


@RoutePage()
  class SearchUsersScreen extends ConsumerStatefulWidget {
  const SearchUsersScreen({super.key});

  @override
  ConsumerState<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends ConsumerState<SearchUsersScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userName = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF0D1117),
      body: SafeArea(
        child: Stack(
          children:[
            Container(
            padding: const EdgeInsets.all(15.0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0D1117),
                    Color(0xFF161B22),
                  ]
              )
            ),
            height: MediaQuery.of(context).size.height * 1.5,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(bottom: keyboardHeight),
                  child: Column(
                    children: [
                      Gap(80),
                      Text("GitHub Explorer", style: themeData().primaryTextTheme.headlineLarge),
                      Gap(120),
                      TextFormField(
                        controller: _userName,
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: 'Search Users',
                          hintStyle: themeData().primaryTextTheme.labelMedium,
                          prefixIcon: Icon(Iconsax.user, color: Colors.yellow,),
                          contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                          prefixIconConstraints: BoxConstraints(minWidth: 50),
                          counterText: "",
                          filled: true,
                          fillColor: Colors.transparent,
                          border: themeData().inputDecorationTheme.border
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username cannot be empty';
                          }
                          return null;
                        },
                        onChanged: (v){
                          _userName.text = v.toString();
                        },
                      ),
                      Gap(40),
                      (!isLoading)?LoginButton(
                        showActions: false,
                        title: "Submit",
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                isLoading = true;
                              });

                              final username = _userName.text.trim();
                              final provider = ref.read(searchUserProvider);

                              await provider.searchUser(username);
                              print(provider.error);
                              if (provider.error != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(provider.error.toString())),
                                );
                                setState(() {
                                  isLoading = false;
                                });
                              } else {
                                final user = provider.user;
                                print(user!.name.toString());
                                if (user != null) {
                                  final userJson = jsonEncode(user.toJson());
                                  await HiveRepo.instance.storeData("github_user", userJson);
                                }
                                context.pushRoute(HomeRoute());
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          }

                      ):SizedBox(
                        child: CircularProgressIndicator(color: Colors.white30,strokeWidth: 2,),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ]
        ),
      ),
    );
  }
}
