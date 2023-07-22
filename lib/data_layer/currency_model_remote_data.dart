import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/currency_model.dart';

class CurrencyConverterRemoteDataSource{
  //call list all currencies api
  static Future<List<CurrencyModel>> listAllAvailableCurrencies()async{
    final uri  =  Uri.parse("https://api.freecurrencyapi.com/v1/currencies?apikey=N8na7dQL8kt7phAWoSS4brbPX97Ubjo9ydW8JyMN&currencies=");
    print(uri);
    var response = await http.get(uri);
    print(response.statusCode);
    // print(response.body);
    if(response.statusCode==200){
      var decodedBody = json.decode(response.body) as Map<String,dynamic>;
      return (decodedBody["data"] as Map<String,dynamic>).
      values.map((e) => CurrencyModel.fromMap(e)).toList();
    }
    return [];
  }
}