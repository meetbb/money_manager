class TransactionModel {
  int trxnId;
  int trxnAmount;
  String trxnDate;
  int categoryId;
  int subCategoryId;
  String description;
  String imagePath;
  String lastModifiedDate;

  TransactionModel(
      this.trxnAmount,
      this.trxnDate,
      this.categoryId,
      this.subCategoryId,
      this.description,
      this.imagePath,
      this.lastModifiedDate);

  TransactionModel.map(dynamic obj) {
    this.trxnAmount = obj["trxnAmount"];
    this.trxnDate = obj["trxnDate"];
    this.categoryId = obj["categoryId"];
    this.subCategoryId = obj["subCategoryId"];
    this.description = obj["description"];
    this.imagePath = obj["imagePath"];
    this.lastModifiedDate = obj["lastModifiedDate"];
  }

  int get getTrxnAmount => trxnAmount;
  String get getTrxnDate => trxnDate;
  int get getCategoryId => categoryId;
  int get getSubCategoryId => subCategoryId;
  String get getDescription => description;
  String get getImagePath => imagePath;
  String get getLastModifiedDate => lastModifiedDate;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["trxnAmount"] = trxnAmount;
    map["trxnDate"] = trxnDate;
    map["categoryId"] = categoryId;
    map["subCategoryId"] = subCategoryId;
    map["description"] = description;
    map["imagePath"] = imagePath;
    map["lastModifiedDate"] = lastModifiedDate;
    return map;
  }

  void setTrxnId(int id) {
    this.trxnId = id;
  }
}
