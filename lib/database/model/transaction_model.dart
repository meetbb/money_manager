class TransactionModel {
  
  int trxnId;
  String trxnName;
  String trxnAmount;
  String trxnDate;
  String trxnCategory;

  TransactionModel(this.trxnName, this.trxnAmount, this.trxnDate, this.trxnCategory);

  TransactionModel.map(dynamic obj) {
    this.trxnName = obj["transactionname"];
    this.trxnAmount = obj["transactionamount"];
    this.trxnDate = obj["transactiondate"];
    this.trxnCategory = obj["transactioncategory"];
  }

  String get getTrxnName => trxnName;

  String get getTrxnAmount => trxnAmount;

  String get getTrxnDate => trxnDate;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["transactionname"] = trxnName;
    map["transactionamount"] = trxnAmount;
    map["transactiondate"] = trxnDate;
    map["transactioncategory"] = trxnCategory;
    return map;
  }

  void setUserId(int id) {
    this.trxnId = id;
  }
}
