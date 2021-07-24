import 'package:books/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';


class Read extends StatefulWidget {
  final data;
  const Read({Key? key, required this.data}) : super(key: key);

  @override
  _ReadState createState() => _ReadState();
}

class _ReadState extends State<Read> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          splashColor: Colors.blueAccent,
          backgroundColor: Colors.blueAccent
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);

            },
            icon: Icon(Icons.arrow_back),
          ),
          elevation: 0,
          title: Text("${widget.data['title']}"),
          bottom: PreferredSize(

            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 70),
              child: Text("${widget.data['author']}", style: TextStyle(color: Colors.white70),),
            ),
            preferredSize: Size.fromHeight(30),
          ),
          backgroundColor: Colors.blueAccent,

        ),
        body: const PDF().cachedFromUrl(
          widget.data['url'],
          placeholder: (double progress) => Center(child: Text('$progress %')),
          errorWidget: (dynamic error) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }
}
