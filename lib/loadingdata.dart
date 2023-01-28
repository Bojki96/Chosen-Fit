import 'package:flutter/material.dart';

class LoadingData extends StatelessWidget {
  LoadingData({Key key, @required this.text, this.imagePicked})
      : super(key: key);
  double fontSize = 21;
  String text;
  String imagePicked;
  @override
  Widget build(BuildContext context) {
    if (imagePicked == null) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white.withOpacity(0.5),
        child: Center(
          child: SizedBox(
            height: 80,
            width: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 95, 60, 146),
                    strokeWidth: 6,
                  ),
                ),
                Text(
                  text,
                  style: TextStyle(
                    color: Color.fromARGB(255, 95, 60, 146),
                    fontSize: fontSize - 5,
                    decoration: TextDecoration.none,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: SizedBox(
          height: 80,
          width: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 95, 60, 146),
                  strokeWidth: 6,
                ),
              ),
              Text(
                text,
                style: TextStyle(
                    color: Color.fromARGB(255, 95, 60, 146),
                    fontSize: fontSize - 5),
              )
            ],
          ),
        ),
      );
    }
  }
}
