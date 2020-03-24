class SubCategoryModel {
  int subCategoryId;
  String subCategoryName;
  int categoryId;
  int subCategoryType;
  String logo;
  int position;

  SubCategoryModel(this.subCategoryName, this.categoryId, this.subCategoryType,
      this.logo, this.position);

  SubCategoryModel.map(dynamic obj) {
    this.subCategoryName = obj["categoryName"];
    this.categoryId = obj["categoryId"];
    this.subCategoryType = obj["subCategoryType"];
    this.logo = obj["logo"];
    this.position = obj["position"];
  }

  int get getSubCategoryId => subCategoryId;

  String get getSubCategoryName => subCategoryName;

  int get getCategoryId => categoryId;

  int get getSubCategoryType => subCategoryType;

  String get getLogo => logo;

  int get getPosition => position;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["subCategoryName"] = subCategoryName;
    map["categoryId"] = categoryId;
    map["subCategoryType"] = subCategoryType;
    map["logo"] = logo;
    map["position"] = position;
    return map;
  }

  void setSubCategoryId(int id) {
    this.subCategoryId = id;
  }
}
