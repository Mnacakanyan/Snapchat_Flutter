import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
class ShimmerWidget extends StatefulWidget {
  const ShimmerWidget({ Key? key }) : super(key: key);

  @override
  _ShimmerWidgetState createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Shimmer.fromColors(
        highlightColor: Colors.white,
        baseColor: Colors.grey[500]!,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              _fields()
            ]
          ),
        ),
      ),
    );
  }
  Widget _fields(){
    return Text('');
  }
}