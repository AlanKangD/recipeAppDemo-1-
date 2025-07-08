import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../utils/constants.dart';
import '../widgets/brand_app_bar.dart';
import '../widgets/category_filter.dart';
import '../widgets/recipe_list_item.dart';
import '../widgets/recommended_recipe_carousel.dart';
import 'recipe_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfdfdfd),
      body: Consumer<RecipeProvider>(
        builder: (context, recipeProvider, child) {
          return Column(
            children: [
              // 브랜드 앱바
              BrandAppBar(
                onSearchPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
              ),
              // 추천 레시피 캐러셀
              _buildRecommendedSection(context, recipeProvider),
              // 카테고리 필터
              _buildCategorySection(recipeProvider),
              // 레시피 리스트
              Expanded(
                child: _buildRecipeList(context, recipeProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRecommendedSection(
      BuildContext context, RecipeProvider recipeProvider) {
    // 추천 레시피 (처음 3개)
    final recommendedRecipes = recipeProvider.recipes.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
          child: Row(
            children: [
              const Text(
                '🔥 추천 레시피',
                style: TextStyle(
                  fontFamily: 'Cafe24Ssurround',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // 랜덤 추천 기능
                  if (recipeProvider.recipes.isNotEmpty) {
                    final randomRecipe = recipeProvider.recipes[
                        DateTime.now().millisecond %
                            recipeProvider.recipes.length];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecipeDetailScreen(recipe: randomRecipe),
                      ),
                    );
                  }
                },
                child: const Text(
                  '랜덤 추천',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        RecommendedRecipeCarousel(
          recipes: recommendedRecipes,
          onRecipeTap: (recipe) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(recipe: recipe),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategorySection(RecipeProvider recipeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
          child: Text(
            '🧭 카테고리',
            style: TextStyle(
              fontFamily: 'Cafe24Ssurround',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: AppSizes.paddingSmall),
        CategoryFilterWidget(
          categories: recipeProvider.categories,
          selectedCategories: recipeProvider.selectedCategories,
          onCategorySelected: recipeProvider.toggleCategory,
        ),
      ],
    );
  }

  Widget _buildRecipeList(BuildContext context, RecipeProvider recipeProvider) {
    final recipes = recipeProvider.filteredRecipes;

    if (recipes.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingLarge),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
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
}
