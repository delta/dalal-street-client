
import 'package:flutter/material.dart';

import '../theme/colors.dart';

class NewsDetail extends StatelessWidget {
final int index;
final String text;
final String imagePath;
final String headline;
  const NewsDetail({ Key? key ,required this.index, required this.text, required this.imagePath, required this.headline }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Container(
        color: Colors.black,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: 
      Column(
        mainAxisAlignment: MainAxisAlignment.start ,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.2,
            child: Flexible(child: Padding(padding: const EdgeInsets.fromLTRB(5,20,5,10),
            child: Text(headline,style: const TextStyle(fontSize: 20),)),fit: FlexFit.loose,),
          ),
        
          ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    image: NetworkImage(imagePath),
                    width: MediaQuery.of(context).size.width*0.5,
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),

          ),
          Container(
            margin: const EdgeInsets.fromLTRB(5, 20, 5, 0),

            child:
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Flexible(
              child: Padding(padding: const EdgeInsets.fromLTRB(10,10,10,10),
            child: Text(text,textAlign: TextAlign.start,style: const TextStyle(fontSize: 16,color: whiteWithOpacity75),)),fit: FlexFit.loose,),
          ),
          decoration: BoxDecoration(
      color: background2, borderRadius: BorderRadius.circular(10)),),
          ]),
    ));
  }
}