import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../utils/constants.dart';
import '../widgets/category_filter.dart';
import '../widgets/recipe_card.dart';
import '../widgets/search_bar.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<RecipeProvider>(
          builder: (context, recipeProvider, child) {
            return Column(
              children: [
                // 상단 검색바
                SearchBarWidget(
                  onChanged: recipeProvider.searchRecipes,
                ),
                // 카테고리 필터
                CategoryFilterWidget(
                  categories: recipeProvider.categories,
                  selectedCategories: recipeProvider.selectedCategories,
                  onCategorySelected: recipeProvider.toggleCategory,
                ),
                // 레시피 목록
                Expanded(
                  child: recipeProvider.filteredRecipes.isEmpty
                      ? _buildEmptyState()
                      : _buildRecipeList(context, recipeProvider),
                ),
              ],
            );
          },
        ),
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

  Widget _buildRecipeList(BuildContext context, RecipeProvider recipeProvider) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingLarge),
      itemCount: recipeProvider.filteredRecipes.length,
      itemBuilder: (context, index) {
        final recipe = recipeProvider.filteredRecipes[index];
        return RecipeCard(
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
