import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';

class IpoPage extends StatefulWidget {
  const IpoPage({ Key? key }) : super(key: key);

  @override
  _IpoPageState createState() => _IpoPageState();
}

class _IpoPageState extends State<IpoPage> {
  @override
  Widget build(BuildContext context) { 
    return Scaffold(
//    appBar:  const TabBar(
//     //  controller: TabController(length: 2,
//     //   vsync: this,
//     //   initialIndex: 0),
//   isScrollable: true, 
//   unselectedLabelColor: Colors.white30, 
//   labelPadding: EdgeInsets.symmetric(horizontal: 30), 
//   indicator: UnderlineTabIndicator(
//     borderSide: BorderSide(color: Colors.white, width: 2), 
//     insets: EdgeInsets.symmetric(horizontal: 48),
//   ),
//   tabs: [
//     Tab(text: 'Listings'),
//     Tab(text: 'My Orders'),
//   ],
// ),
      body:
    
     Container(
      child: SingleChildScrollView(child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

       IPOItem()
       
      ]),)
    )
    );
  }
}

Widget IPOItem() {
  return Card(
    child: Column(children: [
      Row(
        children: [
          Image.asset('',
          width: 50,
          height: 50,),
          
        ],
      )
    ]),
    color: background2,
    
  );
}