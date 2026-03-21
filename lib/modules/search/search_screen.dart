import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_gram/cubit/post_cubit/cubit.dart';
import 'package:mini_gram/cubit/post_cubit/states.dart';
import 'package:mini_gram/generated/l10n.dart'; 
import 'package:mini_gram/models/post_model.dart';
import 'package:mini_gram/models/user_model.dart';
import 'package:mini_gram/modules/chats_details/chat_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _users = [];
  List<postModel> _filteredPosts = [];
  bool _isSearching = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query, List<postModel> allPosts) async {
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _users = [];
        _filteredPosts = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _isLoading = true;
    });

    try {
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(10)
          .get();

      final users = usersSnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();

      final filteredPosts = allPosts
          .where((post) =>
              post.text != null &&
              post.text!.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        _users = users;
        _filteredPosts = filteredPosts;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    return BlocBuilder<PostCubit, PostStates>(
      builder: (context, state) {
        final allPosts = PostCubit.get(context).posts;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => _search(val, allPosts),
                    decoration: InputDecoration(
                      hintText: s.searchHint,
                      hintStyle: TextStyle(color: theme.hintColor),
                      prefixIcon: Icon(Icons.search, color: theme.hintColor),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.close, color: theme.hintColor),
                              onPressed: () {
                                _searchController.clear();
                                _search('', allPosts);
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: colorScheme.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
            
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _isSearching
                          ? _buildSearchResults(context, theme, colorScheme)
                          : _buildExploreGrid(context, allPosts),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExploreGrid(BuildContext context, List<postModel> allPosts) {
    final theme = Theme.of(context);
    final s = S.of(context);
    final postsWithImages = allPosts
        .where((p) => p.postImage != null && p.postImage!.isNotEmpty)
        .toList();

    if (postsWithImages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.explore_outlined,
                size: 64, color: theme.colorScheme.outline),
            const SizedBox(height: 12),
            Text(
              s.noPostsExplore,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: postsWithImages.length,
      itemBuilder: (context, index) {
        final post = postsWithImages[index];
        return GestureDetector(
          onTap: () => _showPostPreview(context, post),
          child: Container(
            color: theme.colorScheme.surfaceVariant,
            child: Image.network(
              post.postImage!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                  ),
                );
              },
              errorBuilder: (_, __, ___) => Icon(
                Icons.broken_image_outlined,
                color: theme.colorScheme.outline,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    final s = S.of(context);
    final hasUsers = _users.isNotEmpty;
    final hasPosts = _filteredPosts.isNotEmpty;

    if (!hasUsers && !hasPosts) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: colorScheme.outline),
            const SizedBox(height: 12),
            Text(
              s.noResultsFound,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        if (hasUsers) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              s.users,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.outline,
              ),
            ),
          ),
          ..._users.map(
            (user) => ListTile(
              leading: CircleAvatar(
                backgroundColor: colorScheme.surfaceVariant,
                backgroundImage: (user.image != null && user.image!.isNotEmpty)
                    ? NetworkImage(user.image!)
                    : null,
                child: (user.image == null || user.image!.isEmpty)
                    ? Icon(Icons.person, color: colorScheme.outline)
                    : null,
              ),
              title: Text(
                user.name ?? s.miniGramUser,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                user.bio ?? '',
                style: theme.textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatDetailsScreen(userModel: user),
                ),
              ),
            ),
          ),
        ],
        if (hasPosts) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              s.posts,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.outline,
              ),
            ),
          ),
          ..._filteredPosts.map(
            (post) => ListTile(
              leading: CircleAvatar(
                backgroundColor: colorScheme.surfaceVariant,
                backgroundImage: (post.image != null && post.image!.isNotEmpty)
                    ? NetworkImage(post.image!)
                    : null,
              ),
              title: Text(
                post.name ?? s.unknownUser,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                post.text ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
              onTap: () => _showPostPreview(context, post),
            ),
          ),
        ],
      ],
    );
  }

  void _showPostPreview(BuildContext context, postModel post) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: colorScheme.surfaceVariant,
                      backgroundImage: (post.image != null && post.image!.isNotEmpty)
                          ? NetworkImage(post.image!)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      post.name ?? s.unknownUser,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (post.postImage != null && post.postImage!.isNotEmpty)
                Image.network(
                  post.postImage!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              if (post.text != null && post.text!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    post.text!,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}