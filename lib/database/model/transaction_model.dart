class TransactionModel {
  
  int trxnId;
  String trxnName;
  String trxnAmount;
  String trxnDate;
  String trxnCategory;
  bool isWithDrawal;

  TransactionModel(this.trxnName, this.trxnAmount, this.trxnDate, this.trxnCategory, this.isWithDrawal);

  TransactionModel.map(dynamic obj) {
    this.trxnName = obj["transactionname"];
    this.trxnAmount = obj["transactionamount"];
    this.trxnDate = obj["transactiondate"];
    this.trxnCategory = obj["transactioncategory"];
    this.isWithDrawal = obj["iswithdrawal"];
  }

  String get getTrxnName => trxnName;

  String get getTrxnAmount => trxnAmount;

  String get getTrxnDate => trxnDate;

  bool get isWithdrawal => isWithDrawal;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["transactionname"] = trxnName;
    map["transactionamount"] = trxnAmount;
    map["transactiondate"] = trxnDate;
    map["transactioncategory"] = trxnCategory;
    map["iswithdrawal"] = isWithDrawal;
    return map;
  }

  void setUserId(int id) {
    this.trxnId = id;
  }
}
