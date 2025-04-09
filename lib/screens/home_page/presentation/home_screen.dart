import 'dart:convert';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skyislimit/screens/home_page/presentation/profile_tab.dart';
import 'package:skyislimit/screens/home_page/presentation/repository_tab.dart';

import '../../../rest/hive_repo.dart';
import '../../../widgets/custome_appbar.dart';
import '../../../widgets/homepage_loader.dart';
import '../../searchUser/model/search_result_users_model.dart';
import '../model/user_repos_model.dart';
import '../provider/home_page_provider.dart';

@RoutePage()
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  SearchGitUsers? user;
  List<UserRepositories>? repos;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final userJson = HiveRepo.instance.readData("github_user");
      if (userJson == null) throw Exception("No user data in Hive");

      user = SearchGitUsers.fromJson(jsonDecode(userJson));

      await ref.read(homePageProvider).getUserRepos(user!.login ?? '');
      repos = ref.read(homePageProvider).userRepos;
    } catch (e) {
      error = e.toString();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: ShimmerProfileTabView()));
    if (error != null) {
      return Scaffold(
        body: Center(
          child: Text(error!, style: const TextStyle(color: Colors.red)),
        ),
      );
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: buildGitHubAppBar(context, title: "GitHub Explorer"),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: TabBarView(
            children: [
              ProfileTabView(user: user!, repos: repos ?? []),
              RepositoryTabView(repos: repos ?? []),
            ],
          ),
        ),
      ),
    );
  }
}

