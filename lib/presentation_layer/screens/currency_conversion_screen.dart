import 'dart:convert';

import 'package:currency_convertor/app_layer/app_colors.dart';
import 'package:currency_convertor/app_layer/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app_layer/text_styles.dart';
import '../../data_layer/currency_model_remote_data.dart';
import '../../data_layer/models/currency_model.dart';
import 'package:http/http.dart' as http;



class CurrencyConversion extends StatefulWidget {
  const CurrencyConversion({super.key});

  @override
  State<CurrencyConversion> createState() => _CurrencyConversionState();
}

class _CurrencyConversionState extends State<CurrencyConversion> {
  String defaultImageUrl= "https://cdn.britannica.com/33/4833-004-828A9A84/Flag-United-States-of-America.jpg";

  String selectedCurrencyCode = "USD";
  final convertedcontrol = TextEditingController();

  String convertedValue = "0";
  final List<CurrencyModel> currencies = [];
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    CurrencyConverterRemoteDataSource.listAllAvailableCurrencies().then(
            (value){
          currencies.addAll(value);
          print("from then ${value.length}");
        },
        onError: (error){
          print("from error ${error.toString()}");
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appbarTitle,style: TextStyles.appbarTextStyle),
        backgroundColor: AppColors.mainAppbarColor,

      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 32,horizontal: 16),
        children: [
          32.verticalSpace,
          Row(
            children: [
              //button
              Expanded(

                flex: 1,
                child:  InkWell(

                  onTap: (){
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx){
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32,vertical: 16),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              )
                          ),
                          height: 700,
                          child: ListView.separated(
                            itemCount: currencies.length,
                            itemBuilder: (context,index){
                              return InkWell(
                                onTap: (){
                                  selectedCurrencyCode =currencies[index].code??"USD";
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    // currency name
                                    Text(currencies[index].name??"",
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const Spacer(),
                                    // symbol
                                    Text(currencies[index].symbol??""),
                                    const SizedBox(width: 6,),
                                    //code
                                    Text(currencies[index].code??""),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return const Divider(
                                color: Colors.blue,
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: SizedBox(

                    height: 40.h,
                    child: Center(

                      child: Text(
                        selectedCurrencyCode,
                        style: TextStyle(
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // SizedBox(width: 16.w,),
              16.horizontalSpace,
              Expanded(
                flex: 2,
                child:  SizedBox(
                  height: 40.h,
                  child: TextField(
                    controller: convertedcontrol,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          32.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //button
              Container(
                width: 80,
                height: 80,
                child: Image.network(defaultImageUrl),
              ),
              Text("$convertedValue"+" USDs",style: const TextStyle(fontSize: 20),),
            ],
          ),
          64.verticalSpace,


          isLoading?
          const Center(
            child: CircularProgressIndicator(),
          )
              :
          TextButton(
            //TODO: call controller method
            onPressed: ()async{
              isLoading = true;
              setState(() {});
              // final uri  =  Uri.parse("https://api.freecurrencyapi.com/v1/latest?apikey=N8na7dQL8kt7phAWoSS4brbPX97Ubjo9ydW8JyMN&currencies=EUR");
              Uri uri= Uri(
                scheme: "https",
                host: "api.freecurrencyapi.com",
                path: "v1/latest",
                queryParameters: {
                  "apikey":"N8na7dQL8kt7phAWoSS4brbPX97Ubjo9ydW8JyMN",
                  "currencies":selectedCurrencyCode,
                },
              );
              print(uri);
              var response = await http.get(uri);
              print(response.statusCode);
              print(response.body);
              if(response.statusCode==200){
                var decodedBody = json.decode(response.body) as Map<String,dynamic>;
                num rate  = decodedBody["data"][selectedCurrencyCode];
                print(rate);
                 convertedValue = ((double.parse(convertedcontrol.text))/rate).toString();
                setState(() {});
                print(convertedValue);
                isLoading = false;
                setState(() {});
              }
              else{
                isLoading = false;
                setState(() {});
                print("error");
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: const Text(
              AppStrings.conversion,
              style: TextStyle(fontSize: 20,color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}