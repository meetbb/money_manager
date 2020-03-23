class CategoryModel {
  
  int categoryId;
  String categoryName;
  int position;

  CategoryModel(this.categoryName, this.position);

  CategoryModel.map(dynamic obj) {
    this.categoryName = obj["categoryName"];
    this.position = obj["position"];
  }

  int get getCategoryId => categoryId;

  String get getCategoryName => categoryName;

  int get getPosition => position;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["categoryName"] = categoryName;
    map["position"] = position;
    return map;
  }
   void setCategoryId(int id) {
    this.categoryId = id;
  }
}
