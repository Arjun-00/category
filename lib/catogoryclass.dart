import 'dart:convert';

List<AllCategory> allCategoryFromJson(String str) => List<AllCategory>.from(json.decode(str).map((x) => AllCategory.fromJson(x)));
String allCategoryToJson(List<AllCategory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class AllCategory {
  AllCategory({
    required this.productCategoryId,
    required this.isActive,
    required this.name,
    required this.parentCategoryId,
    required this.isChecked
  });
  int productCategoryId;
  String isActive;
  String name;
  int parentCategoryId;
  bool isChecked;
  factory AllCategory.fromJson(Map<String, dynamic> json) => AllCategory(
    productCategoryId: json["productCategoryId"],
    isActive: json["isActive"],
    name: json["name"],
    parentCategoryId: json["parentCategoryId"],
    isChecked: false
  );
  Map<String, dynamic> toJson() => {
    "productCategoryId": productCategoryId,
    "isActive": isActive,
    "name": name,
    "parentCategoryId": parentCategoryId,
    "isChecked": isChecked
  };
}


class SubCategory{
  int parentId;
  int level;
  List<AllCategory> listCategory;
  SubCategory(this.parentId,this.level, this.listCategory);
}

class SelectedItem{
  int levels;
  int productCategoryId;
  int productParentId;
  int index;
  String name;

  SelectedItem(this.levels,this.productCategoryId,this.productParentId,this.index,this.name);
}

