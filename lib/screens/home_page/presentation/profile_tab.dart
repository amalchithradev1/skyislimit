
import 'package:flutter/material.dart';
import 'package:skyislimit/theme/themes.dart';
import '../../searchUser/model/search_result_users_model.dart';
import '../model/user_repos_model.dart';
import 'package:intl/intl.dart';

class ProfileTabView extends StatelessWidget {
  final SearchGitUsers user;
  final List<UserRepositories> repos;
  const ProfileTabView({super.key, required this.user, required this.repos});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd MMM yyyy');
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 40, backgroundImage: NetworkImage(user.avatarUrl ?? '')),
          const SizedBox(height: 16),
          Text("Name : ${user.name ?? 'N/A'}", style: themeData().primaryTextTheme.labelLarge),
          Text("Username : ${user.login}", style: themeData().primaryTextTheme.labelLarge),
          Text("Followers : ${user.followers}", style: themeData().primaryTextTheme.labelLarge),
          Text("Following : ${user.following}", style: themeData().primaryTextTheme.labelLarge),
          Text("Bio : ${user.bio ?? 'N/A'}", style: themeData().primaryTextTheme.labelLarge),
          const SizedBox(height: 12),
          Text("Repositories : ${repos.length}", style: themeData().primaryTextTheme.labelLarge),
          Divider(color: Colors.black38),
          const SizedBox(height: 12),
          if (user.company != null)
            Text("Company : ${user.company}", style: themeData().primaryTextTheme.labelLarge),
          if (user.location != null)
            Text("Location : ${user.location}", style: themeData().primaryTextTheme.labelLarge),
          if (user.blog != null && user.blog!.isNotEmpty)
            Text("Website : ${user.blog}", style: themeData().primaryTextTheme.labelLarge),
          if (user.twitterUsername != null && user.twitterUsername!.isNotEmpty)
            Text("Twitter : @${user.twitterUsername}", style: themeData().primaryTextTheme.labelLarge),
          if (user.email != null)
            Text("Email : ${user.email}", style: themeData().primaryTextTheme.labelLarge),
          if (user.createdAt != null)
            Text("Joined : ${formatter.format(DateTime.parse(user.createdAt!))}",
                style: themeData().primaryTextTheme.labelLarge),
        ],
      ),
    );
  }
}

