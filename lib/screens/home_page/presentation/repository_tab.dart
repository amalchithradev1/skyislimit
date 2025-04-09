import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:google_fonts/google_fonts.dart';

import '../model/user_repos_model.dart';

class RepositoryTabView extends StatefulWidget {
  final List<UserRepositories> repos;

  const RepositoryTabView({super.key, required this.repos});

  @override
  State<RepositoryTabView> createState() => _RepositoryTabViewState();
}

class _RepositoryTabViewState extends State<RepositoryTabView> {
  String searchQuery = '';
  String selectedFilter = '';

  void sortRepositories() {
    if (selectedFilter == 'size') {
      widget.repos.sort((a, b) => (b.size ?? 0).compareTo(a.size ?? 0));
    } else if (selectedFilter == 'watchers') {
      widget.repos.sort((a, b) => (b.watchersCount ?? 0).compareTo(a.watchersCount ?? 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredRepos = widget.repos.where((repo) =>
    repo.name?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search repositories...",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: PopupMenuButton<String>(
                icon: const Icon(Icons.filter_list),
                onSelected: (value) {
                  setState(() {
                    selectedFilter = value;
                    sortRepositories();
                  });
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'size', child: Text('Size')),
                  const PopupMenuItem(value: 'watchers', child: Text('Watchers')),
                ],
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: (val) {
              setState(() {
                searchQuery = val;
              });
            },
          ),

        ),
        Expanded(
          child: filteredRepos.isEmpty
              ? const Center(child: Text("No repositories found."))
              : AnimationLimiter(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredRepos.length,
              itemBuilder: (context, index) {
                final repo = filteredRepos[index];

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          if (repo.htmlUrl != null) {
                            _launchURL(repo.htmlUrl!);
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 1,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [Colors.deepPurple.shade100, Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        repo.name ?? 'No Name',
                                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const Icon(Icons.open_in_new, size: 18, color: Colors.deepPurple),
                                  ],
                                ),
                                if (repo.description != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    repo.description!,
                                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                                  ),
                                ],
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 12,
                                  children: [
                                    _buildMetaChip(Icons.star, "${repo.stargazersCount ?? 0} stars"),
                                    _buildMetaChip(Icons.call_split, "${repo.forksCount ?? 0} forks"),
                                    if (repo.language != null)
                                      _buildMetaChip(Icons.code, repo.language!),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )

                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildMetaChip(IconData icon, String label) {
    return Chip(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.deepPurple.shade50,
      avatar: Icon(icon, size: 16, color: Colors.deepPurple),
      label: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }


  void _launchURL(String url) async {
    try {
      await custom_tabs.launch(
        url,
        customTabsOption: const custom_tabs.CustomTabsOption(
          toolbarColor: Colors.deepPurple,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
        ),
      );
    } catch (e) {
      debugPrint('Could not launch $url: $e');
    }
  }


}
