import 'package:flutter/material.dart';
import 'package:pro/services/api_client.dart';
import 'package:pro/widgets/drop_down.dart';

void main() => runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Currency Converter",
      home: CurrencyConverter(),
    ));

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final fromController = new TextEditingController();
  ApiClient client = new ApiClient();
  Color mainColor = Color(0xFF212936);
  Color secondColor = Color(0xFF2849E5);

  List<String> currencies;
  String from;
  String to;
  double rate;
  String result = "";

  Future<List<String>> getCurrrencyList() async {
    return await client.getCurrencies();
  }

  @override
  void initState() {
    super.initState();
    (() async {
      List<String> list = await client.getCurrencies();
      setState(() {
        currencies = list;
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200.0,
                child: Text(
                  "Currency Converter",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        onSubmitted: (value) async{
                          rate = await client.getRate(from, to);
                          setState(() {
                            result = (rate * double.parse(value)).toStringAsFixed(3);                          
                              });
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Input Value To Convert",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              color: secondColor,
                            )),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customDropDown(currencies, from, (val) {
                            setState(() {
                              from = val;
                            });
                          }),
                          FloatingActionButton(
                            onPressed: () {
                              String temp=from;
                              setState(() {
                                  from = to;
                                  to=temp;                           
                                });
                            },
                            child: Icon(Icons.swap_horiz),
                            elevation: 0.0,
                            backgroundColor: secondColor,
                          ),
                          customDropDown(currencies, to, (val) {
                            setState(() {
                              to = val;
                            });
                          }),
                        ],
                      ),
                      SizedBox(height: 50.0,),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),),
                      child: Column(
                        children: [
                          Text("Result",style: TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          )),
                          Text(result,style: TextStyle(
                            color: secondColor,
                            fontSize: 36.0,
                            fontWeight: FontWeight.bold,
                          ),),
                        ],
                      ),),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
