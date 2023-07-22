class CurrencyModel{
  CurrencyModel({
    this.symbol,
    this.name,
    this.symbol_native,
    this.decimal_digits,
    this.rounding,
    this.code,
    this.name_plural,
  });
  String? symbol;
  String? name;
  String? symbol_native;
  num? decimal_digits;
  num? rounding;
  String? code;
  String? name_plural;

  CurrencyModel.fromMap(Map<String,dynamic> e){
    name= e['name'];
    code= e['code'];
    decimal_digits = e['decimal_digits'];
    name_plural= e['name_plural'];
    rounding = e['rounding'];
    symbol = e['symbol'];
    symbol_native = e['symbol_native'];
  }
}