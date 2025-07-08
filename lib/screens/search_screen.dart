import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../utils/constants.dart';
import '../widgets/recipe_list_item.dart';
import '../widgets/search_bar.dart';
import 'recipe_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfdfdfd),
      appBar: AppBar(
        title: const Text('검색'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<RecipeProvider>(
        builder: (context, recipeProvider, child) {
          return Column(
            children: [
              // 검색바
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingMedium),
                child: SearchBarWidget(
                  initialValue: recipeProvider.searchQuery,
                  onChanged: recipeProvider.searchRecipes,
                ),
              ),
              // 검색 결과
              Expanded(
                child: recipeProvider.filteredRecipes.isEmpty
                    ? _buildEmptyState()
                    : _buildSearchResults(context, recipeProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 16),
          Text(
            '검색 결과가 없습니다',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '다른 재료나 카테고리를 시도해보세요',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(
      BuildContext context, RecipeProvider recipeProvider) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingLarge),
      itemCount: recipeProvider.filteredRecipes.length,
      itemBuilder: (context, index) {
        final recipe = recipeProvider.filteredRecipes[index];
        return RecipeListItem(
          recipe: recipe,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(recipe: recipe),
              ),
            );
          },
          onFavoriteToggle: () {
            recipeProvider.toggleFavorite(recipe.id);
          },
        );
      },
    );
  }
}
