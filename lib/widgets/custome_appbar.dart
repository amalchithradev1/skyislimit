import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../routes/app_router.gr.dart';

PreferredSizeWidget buildGitHubAppBar(BuildContext context, {required String title}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    automaticallyImplyLeading: false,
    leading: GestureDetector(
      onTap: () => context.pushRoute(SearchUsersRoute()),
      child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
    ),
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0D1117),
            Color(0xFF161B22),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    centerTitle: true,
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottom: const TabBar(
      indicatorColor: Colors.white,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      tabs: [
        Tab(text: 'Profile'),
        Tab(text: 'Repositories'),
      ],
    ),
  );
}
