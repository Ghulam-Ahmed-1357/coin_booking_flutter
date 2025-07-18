class CoinDataModel {
  List<Data>? data;
  int? timestamp;

  CoinDataModel({this.data, this.timestamp});

  CoinDataModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Data {
  String? id;
  String? rank;
  String? symbol;
  String? name;
  String? supply;
  String? maxSupply;
  String? marketCapUsd;
  String? volumeUsd24Hr;
  String? priceUsd;
  String? changePercent24Hr;
  String? vwap24Hr;
  String? explorer;
  Tokens? tokens;

  Data(
      {this.id,
      this.rank,
      this.symbol,
      this.name,
      this.supply,
      this.maxSupply,
      this.marketCapUsd,
      this.volumeUsd24Hr,
      this.priceUsd,
      this.changePercent24Hr,
      this.vwap24Hr,
      this.explorer,
      this.tokens});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rank = json['rank'];
    symbol = json['symbol'];
    name = json['name'];
    supply = json['supply'];
    maxSupply = json['maxSupply'];
    marketCapUsd = json['marketCapUsd'];
    volumeUsd24Hr = json['volumeUsd24Hr'];
    priceUsd = json['priceUsd'];
    changePercent24Hr = json['changePercent24Hr'];
    vwap24Hr = json['vwap24Hr'];
    explorer = json['explorer'];
    tokens =
        json['tokens'] != null ? new Tokens.fromJson(json['tokens']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rank'] = this.rank;
    data['symbol'] = this.symbol;
    data['name'] = this.name;
    data['supply'] = this.supply;
    data['maxSupply'] = this.maxSupply;
    data['marketCapUsd'] = this.marketCapUsd;
    data['volumeUsd24Hr'] = this.volumeUsd24Hr;
    data['priceUsd'] = this.priceUsd;
    data['changePercent24Hr'] = this.changePercent24Hr;
    data['vwap24Hr'] = this.vwap24Hr;
    data['explorer'] = this.explorer;
    if (this.tokens != null) {
      data['tokens'] = this.tokens!.toJson();
    }
    return data;
  }
}

class Tokens {
  List<String>? l56;
  List<String>? l1;
  List<String>? l10;
  List<String>? l101;
  List<String>? l137;
  List<String>? l42161;
  List<String>? l8453;
  List<String>? l43114;
  List<String>? l130;
  List<String>? l480;
  List<String>? l99;
  List<String>? l728126428;

  Tokens(
      {this.l56,
      this.l1,
      this.l10,
      this.l101,
      this.l137,
      this.l42161,
      this.l8453,
      this.l43114,
      this.l130,
      this.l480,
      this.l99,
      this.l728126428});

  Tokens.fromJson(Map<String, dynamic> json) {
  l56 = json['56'] != null ? List<String>.from(json['56']) : null;
  l1 = json['1'] != null ? List<String>.from(json['1']) : null;
  l10 = json['10'] != null ? List<String>.from(json['10']) : null;
  l101 = json['101'] != null ? List<String>.from(json['101']) : null;
  l137 = json['137'] != null ? List<String>.from(json['137']) : null;
  l42161 = json['42161'] != null ? List<String>.from(json['42161']) : null;
  l8453 = json['8453'] != null ? List<String>.from(json['8453']) : null;
  l43114 = json['43114'] != null ? List<String>.from(json['43114']) : null;
  l130 = json['130'] != null ? List<String>.from(json['130']) : null;
  l480 = json['480'] != null ? List<String>.from(json['480']) : null;
  l99 = json['99'] != null ? List<String>.from(json['99']) : null;
  l728126428 = json['728126428'] != null ? List<String>.from(json['728126428']) : null;
}


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['56'] = this.l56;
    data['1'] = this.l1;
    data['10'] = this.l10;
    data['101'] = this.l101;
    data['137'] = this.l137;
    data['42161'] = this.l42161;
    data['8453'] = this.l8453;
    data['43114'] = this.l43114;
    data['130'] = this.l130;
    data['480'] = this.l480;
    data['99'] = this.l99;
    data['728126428'] = this.l728126428;
    return data;
  }
}