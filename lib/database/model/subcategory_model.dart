class SubCategoryModel {
  int subCategoryId;
  String subCategoryName;
  int categoryId;
  int position;

  SubCategoryModel(this.subCategoryName, this.categoryId, this.position);

  SubCategoryModel.map(dynamic obj) {
    this.subCategoryName = obj["categoryName"];
    this.categoryId = obj["categoryId"];
    this.position = obj["position"];
  }

  int get getSubCategoryId => subCategoryId;

  String get getSubCategoryName => subCategoryName;

  int get getCategoryId => categoryId;

  int get getPosition => position;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["subCategoryName"] = subCategoryName;
    map["categoryId"] = categoryId;
    map["position"] = position;
    return map;
  }

  void setSubCategoryId(int id) {
    this.subCategoryId = id;
  }
}
