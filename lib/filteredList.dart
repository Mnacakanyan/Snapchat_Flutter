// ignore_for_file: cascade_invocations

import 'package:emoji_flag_converter/emoji_flag_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'DataBase/db.dart';
import 'blocs/countryCode/countrycodeinmobile_bloc.dart';
import 'changenotifer.dart';
import 'json/countryModel.dart';
import 'login.dart';

class FilteredList extends StatefulWidget {
  const FilteredList({Key? key, this.list}) : super(key: key);
  final List<Country>? list;
  @override
  _FilteredListState createState() => _FilteredListState();
}

class _FilteredListState extends State<FilteredList> {
  List? filteredList;
  List<Country>? list = [];

  var filterBloc = CountrycodeinmobileBloc();

  @override
  void initState() {
    super.initState();
    filterBloc.add(TextChanged(''));
  }

  @override
  Widget build(BuildContext context) {
    var _list = widget.list;
    return BlocProvider(
      create: (context) => filterBloc,
      child: BlocBuilder<CountrycodeinmobileBloc, CountrycodeinmobileState>(
        builder: (context, state) {
          return _renderFilteredList(state, _list);
        },
      ),
    );
  }

  Widget _renderFilteredList(
      CountrycodeinmobileState state, List<Country>? list) {
    return Scaffold(
        body: Container(
      color: Colors.black,
      child: Column(
        children: [
          mySafeArea(context),
          _filterField(state),
          // _countryList(state),
          _countryListTest(state, list)
        ],
      ),
    ));
  }

  Widget _filterField(CountrycodeinmobileState state) {
    return TextFormField(
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search',
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[400],
          )),
      onChanged: (country) async {
        filterBloc.add(TextChanged(country));

        list = await DBProvider.db.filterCountry(country);
        setState(() {});
      },
    );
  }

  // Widget _countryList(CountrycodeinmobileState state) {
  //   return Expanded(
  //       child: FutureBuilder(
  //     future: DBProvider.db.getAllCountries(),
  //     builder: (context, AsyncSnapshot<List<Country>> snapshot) {
  //       // print('state is ${snapshot.data}');
  //       if (!snapshot.hasData) {
  //         return Center(
  //           child: Text(
  //             'Processing...',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         );
  //       }
  //       return state is CountryDetected
  //           ?
  //           //list?.length == 0
  //           ListView.builder(
  //               itemCount: snapshot.data!.length,
  //               itemBuilder: (context, index) {
  //                 return ListTile(
  //                   onTap: () {
  //                     Provider.of<ChangeCountryCode>(context, listen: false)
  //                         .changeCountry(Country(
  //                       e164Cc: snapshot.data?[index].e164Cc,
  //                       iso2Cc: snapshot.data?[index].iso2Cc,
  //                       example: snapshot.data?[index].example,
  //                     ));
  //                     Navigator.of(context).pop(['']);
  //                   },
  //                   title: Row(children: [
  //                     Text(EmojiConverter.fromAlpha2CountryCode(
  //                         (snapshot.data?[index].iso2Cc).toString())),
  //                     Expanded(
  //                         child: Text(
  //                       (snapshot.data![index].name).toString(),
  //                       style: TextStyle(color: Colors.white),
  //                     )),
  //                     Expanded(
  //                         child: Text(snapshot.data![index].e164Cc.toString(),
  //                             textAlign: TextAlign.end,
  //                             style: TextStyle(color: Colors.white))),
  //                   ]),
  //                 );
  //               })
  //           : ListView.builder(
  //               itemCount: list?.length,
  //               itemBuilder: (context, index) {
  //                 return ListTile(
  //                   onTap: () {
  //                     Provider.of<ChangeCountryCode>(context, listen: false)
  //                         .changeCountry(Country(
  //                       e164Cc: list?[index]['e164Cc'],
  //                       iso2Cc: list?[index]['code'],
  //                       example: list?[index]['example'],
  //                     ));
  //                     Navigator.of(context).pop(['']);
  //                     // Navigator.of(context)
  //                     //     .pop([list?[index]['code'], list?[index]['e164Cc']]);
  //                   },
  //                   title: Row(children: [
  //                     Text(EmojiConverter.fromAlpha2CountryCode(
  //                         (list?[index]['code']).toString())),
  //                     Expanded(
  //                         child: Text(
  //                       (list?[index]['name']).toString(),
  //                       style: TextStyle(color: Colors.white),
  //                     )),
  //                     Expanded(
  //                         child: Text((list?[index]['e164Cc']).toString(),
  //                             textAlign: TextAlign.end,
  //                             style: TextStyle(color: Colors.white))),
  //                   ]),
  //                 );
  //               });
  //     },
  //   ));
  // }

  Widget _countryListTest(
      CountrycodeinmobileState state, List<Country>? _list) {
    return Expanded(
        child: state is CountryDetected
            ? ListView.builder(
                itemCount: _list?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Provider.of<ChangeCountryCode>(context, listen: false)
                          .changeCountry(Country(
                        e164Cc: _list?[index].e164Cc,
                        iso2Cc: _list?[index].iso2Cc,
                        example: _list?[index].example,
                      ));
                      Navigator.of(context).pop(['']);
                    },
                    title: Row(
                      children: [
                        Text(EmojiConverter.fromAlpha2CountryCode(
                            (_list?[index].iso2Cc).toString())),
                        Expanded(
                            child: Text(
                          (_list?[index].name).toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                        Expanded(
                            child: Text((_list?[index].e164Cc).toString(),
                                textAlign: TextAlign.end,
                                style: TextStyle(color: Colors.white))),
                      ],
                    ),
                  );
                })
            : ListView.builder(
                itemCount: list?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Provider.of<ChangeCountryCode>(context, listen: false)
                          .changeCountry(Country(
                        e164Cc: list?[index].e164Cc,
                        iso2Cc: list?[index].iso2Cc,
                        example: list?[index].example,
                      ));
                      Navigator.of(context).pop(['']);
                      // Navigator.of(context)
                      //     .pop([list?[index]['code'], list?[index]['e164Cc']]);
                    },
                    title: Row(children: [
                      Text(EmojiConverter.fromAlpha2CountryCode(
                          (list?[index].iso2Cc).toString())),
                      Expanded(
                          child: Text(
                        (list?[index].name).toString(),
                        style: TextStyle(color: Colors.white),
                      )),
                      Expanded(
                          child: Text((list?[index].e164Cc).toString(),
                              textAlign: TextAlign.end,
                              style: TextStyle(color: Colors.white))),
                    ]),
                  );
                }));
  }
}










// class FilteredList extends StatefulWidget {
//    FilteredList({Key? key}) : super(key: key);
//   @override
//   FilteredListState createState() => FilteredListState();
// }

// class FilteredListState extends State<FilteredList> {
//   FilteredListState({Key? key}):super(key: key);
//   late List<Map<String, dynamic>> countries1;
//   List<Map<String, dynamic>> filtered1 = [];
//   FilteredListState.first({required this.country_name, required this.numberCode,});

// List<Map<String, dynamic>> newFilter = [];
//   var newCountryCode;
//   var contextOfPage;
//   Locale? thisLoc;
//   void getContext( context){
//     contextOfPage = context;
//      thisLoc= Localizations.localeOf(contextOfPage);
//   }
  
//   List<dynamic> findCountryCode(){
    
//     if(numberCode == '()'){
      
//       var a = countries1.where((element) => element['flag']==locale1!.countryCode);
      
//       numberCode = a.map((e) => e['code']);
//     }
   
//     return [numberExample.toString(),newNumber.text.toString(),numberCode.toString(),country_name1.toString()];
//   }



//   void filterCountries(String countryName) {
    
    
//     if (countryName.isEmpty) {
//       newFilter = countries1;
//     } else {
//       newFilter = countries1
//           .where((element) =>
//               element["name"].toLowerCase().toString().startsWith(countryName.toLowerCase()))
//           .toList();
//     }
//     setState(() {
//       filtered1 = newFilter;
//     });
//   }
//   List<Country> newFilter2 = [];
//   List<Country> filtered2 =  CountryApiProvider.ins.myList;
//   void filteredCountries(String country) async{
//     if(country.isEmpty){
//       newFilter2 = CountryApiProvider.ins.myList;

//     }else{
//       newFilter2 = CountryApiProvider.ins.myList.where((e) => e.name!.toLowerCase().toString().startsWith(country.toLowerCase())).toList();

//     }
//     setState(() {
//       filtered2 = newFilter2;
//     });
//   }


//  var bbb ;
//   @override
//   void initState() {
//     bbb = CountryApiProvider.ins.getAllCountries();
//     this.locale1;
//     filtered1 = countries1;
//     super.initState();
//   }
// List<Country> myList1 = [];
// var myJson, list10;
  
//   Locale? locale1;

//   var newNumber = TextEditingController();
//   var myData;
//   var flag;
//   var numberExample;
//   var numberCode;
//   var country_name='AM';
//   var country_name1;
//   @override
//   Widget build(BuildContext context) {
//   var newNumber = TextEditingController();
//   var myData;
//   var flag;
//   var numberExample;
  
  
//    country_name1 = this.country_name;
//      locale1 = Localizations.localeOf(context);

//     return Scaffold(
//       body: Container(
//         color: Colors.black,
//         child: Column(
//           children: [
//             mySafeArea(context),
//             TextField(
//               onChanged: (_country) {
//                 setState(() {
//                   filteredCountries(_country);
//                 });
//               },
//               decoration: InputDecoration(
            //       filled: true,
            //       fillColor: Colors.white,
            //       hintText: 'Search',
            //       prefixIcon: Icon(
            //         Icons.search,
            //         color: Colors.grey[400],
            //       )),
            // ),
//             Expanded(
//               child: FutureBuilder<List>(
//                 future: DBProvider.db.getAllCountries(),
//                 builder: (context, AsyncSnapshot<List> snapshot){
//                   if(!snapshot.hasData){
//                     return Center(
//                       child: Text('Processing...', style:TextStyle(color: Colors.white
//                       )),
//                     );
//                   }
//                   return filtered2.length>0?
//                   ListView.builder(
//                     itemCount: filtered2.length,
//                     itemBuilder: (context, index){

//                     return ListTile(
//                       onTap: (){
//                         setState(() {
//                           numberExample = filtered2[index].example;
//                           newNumber.text = filtered2[index].e164Cc.toString();
//                           numberCode = newNumber.text;
//                           country_name1 = filtered2[index].iso2Cc.toString();
//                         });
//                         Navigator.of(context).pop([country_name1,numberCode, numberExample]);
//                       },
//                       title: Row(
//                         children: [
//                           Text(EmojiConverter.fromAlpha2CountryCode(filtered2[index].iso2Cc.toString())),
//                           Expanded(child: Text((filtered2[index].name).toString(), style: TextStyle(color: Colors.white),)),
//                           Expanded(child:Text(filtered2[index].e164Cc.toString(),textAlign: TextAlign.end,style: TextStyle(color: Colors.white))),
//                         ],
//                       ),
//                     );
//                   }):Text('No such country', style: TextStyle(color: Colors.white),);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );

    
//   }
  
  
// }