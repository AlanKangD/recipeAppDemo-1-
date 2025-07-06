class RecipeCategory {
  final String id;
  final String name;
  final String icon;
  final bool isSelected;

  RecipeCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.isSelected = false,
  });

  RecipeCategory copyWith({
    String? id,
    String? name,
    String? icon,
    bool? isSelected,
  }) {
    return RecipeCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
