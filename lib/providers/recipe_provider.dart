import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/category.dart';
import '../models/recipe.dart';

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];
  List<RecipeCategory> _categories = [];
  String _searchQuery = '';
  final List<String> _selectedCategories = [];
  final bool _isLoading = false;

  // Getters
  List<Recipe> get recipes => _recipes;
  List<Recipe> get filteredRecipes => _filteredRecipes;
  List<RecipeCategory> get categories => _categories;
  String get searchQuery => _searchQuery;
  List<String> get selectedCategories => _selectedCategories;
  bool get isLoading => _isLoading;

  // 즐겨찾기 레시피만 가져오기
  List<Recipe> get favoriteRecipes =>
      _recipes.where((recipe) => recipe.isFavorite).toList();

  RecipeProvider() {
    _loadDummyData();
    _loadCategories();
    _loadFavorites();
  }

  // 더미 데이터 로드
  void _loadDummyData() {
    _recipes = [
      Recipe(
        id: '1',
        title: '김치볶음밥',
        description: '남은 김치로 만드는 간단한 볶음밥',
        imageUrl:
            'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400',
        ingredients: ['김치', '밥', '식용유', '참기름', '깨'],
        instructions: [
          '김치를 잘게 썰어주세요.',
          '팬에 식용유를 두르고 김치를 볶아주세요.',
          '밥을 넣고 함께 볶아주세요.',
          '참기름과 깨를 넣고 마무리해주세요.'
        ],
        cookingTime: 10,
        servings: 1,
        categories: ['한식', '간단', '자취요리', '10분이하'],
      ),
      Recipe(
        id: '2',
        title: '계란볶음밥',
        description: '계란 하나로 만드는 간단한 볶음밥',
        imageUrl:
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400',
        ingredients: ['계란', '밥', '양파', '식용유', '소금', '후추'],
        instructions: [
          '양파를 잘게 썰어주세요.',
          '팬에 식용유를 두르고 양파를 볶아주세요.',
          '밥을 넣고 함께 볶아주세요.',
          '계란을 넣고 스크램블해주세요.',
          '소금과 후추로 간을 맞춰주세요.'
        ],
        cookingTime: 8,
        servings: 1,
        categories: ['한식', '간단', '자취요리', '10분이하'],
      ),
      Recipe(
        id: '3',
        title: '라면 스프 활용 계란찜',
        description: '라면 스프로 만드는 간단한 계란찜',
        imageUrl:
            'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?w=400',
        ingredients: ['계란', '라면 스프', '물', '대파'],
        instructions: [
          '계란을 그릇에 깨뜨려주세요.',
          '라면 스프를 넣고 물을 부어 섞어주세요.',
          '대파를 잘게 썰어 넣어주세요.',
          '찜기에 10분간 찜기로 익혀주세요.'
        ],
        cookingTime: 15,
        servings: 1,
        categories: ['한식', '간단', '자취요리'],
      ),
      Recipe(
        id: '4',
        title: '양파 스프',
        description: '양파로 만드는 간단한 스프',
        imageUrl:
            'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400',
        ingredients: ['양파', '버터', '물', '소금', '후추'],
        instructions: [
          '양파를 잘게 썰어주세요.',
          '팬에 버터를 녹이고 양파를 볶아주세요.',
          '물을 넣고 끓여주세요.',
          '소금과 후추로 간을 맞춰주세요.'
        ],
        cookingTime: 20,
        servings: 2,
        categories: ['양식', '간단'],
      ),
    ];
    _filteredRecipes = _recipes;
    notifyListeners();
  }

  // 카테고리 로드
  void _loadCategories() {
    _categories = [
      RecipeCategory(id: '1', name: '한식', icon: '🍚'),
      RecipeCategory(id: '2', name: '간단', icon: '⚡'),
      RecipeCategory(id: '3', name: '자취요리', icon: '🏠'),
      RecipeCategory(id: '4', name: '10분이하', icon: '⏰'),
      RecipeCategory(id: '5', name: '양식', icon: '🍝'),
      RecipeCategory(id: '6', name: '중식', icon: '🥢'),
      RecipeCategory(id: '7', name: '일식', icon: '🍣'),
      RecipeCategory(id: '8', name: '디저트', icon: '🍰'),
    ];
  }

  // 검색 기능
  void searchRecipes(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // 카테고리 필터 토글
  void toggleCategory(String categoryName) {
    if (_selectedCategories.contains(categoryName)) {
      _selectedCategories.remove(categoryName);
    } else {
      _selectedCategories.add(categoryName);
    }
    _applyFilters();
  }

  // 필터 적용
  void _applyFilters() {
    _filteredRecipes = _recipes.where((recipe) {
      // 검색어 필터
      bool matchesSearch = _searchQuery.isEmpty ||
          recipe.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          recipe.ingredients.any((ingredient) =>
              ingredient.toLowerCase().contains(_searchQuery.toLowerCase()));

      // 카테고리 필터
      bool matchesCategory = _selectedCategories.isEmpty ||
          recipe.categories
              .any((category) => _selectedCategories.contains(category));

      return matchesSearch && matchesCategory;
    }).toList();

    notifyListeners();
  }

  // 즐겨찾기 토글
  void toggleFavorite(String recipeId) async {
    final index = _recipes.indexWhere((recipe) => recipe.id == recipeId);
    if (index != -1) {
      _recipes[index] = _recipes[index].copyWith(
        isFavorite: !_recipes[index].isFavorite,
      );
      await _saveFavorites();
      _applyFilters();
    }
  }

  // 즐겨찾기 저장
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = _recipes
        .where((recipe) => recipe.isFavorite)
        .map((recipe) => recipe.id)
        .toList();
    await prefs.setStringList('favorites', favoriteIds);
  }

  // 즐겨찾기 로드
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favorites') ?? [];

    _recipes = _recipes.map((recipe) {
      return recipe.copyWith(isFavorite: favoriteIds.contains(recipe.id));
    }).toList();

    _applyFilters();
  }

  // 레시피 상세 정보 가져오기
  Recipe? getRecipeById(String id) {
    try {
      return _recipes.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      return null;
    }
  }
}
