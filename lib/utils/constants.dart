import 'package:flutter/material.dart';

class AppColors {
  // 메인 컬러
  static const Color primary = Color(0xFF6abf69);
  static const Color secondary = Color(0xFFa9e5bb);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color divider = Color(0xFFE9ECEF);
}

class AppSizes {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
}

class AppStrings {
  static const String appName = "자취생 레시피";
  static const String searchHint = "재료를 입력해보세요 (예: 계란, 양파)";
  static const String todayRecipe = "오늘의 냉털 요리";
  static const String favorites = "즐겨찾기";
  static const String search = "검색";
  static const String home = "홈";
  static const String timer = "타이머";
  static const String share = "공유";
  static const String ingredients = "재료";
  static const String instructions = "조리순서";
  static const String cookingTime = "조리시간";
  static const String servings = "인분";
}

class AppCategories {
  static const List<String> categories = [
    "한식",
    "간단",
    "자취요리",
    "10분이하",
    "양식",
    "중식",
    "일식",
    "디저트"
  ];
}
