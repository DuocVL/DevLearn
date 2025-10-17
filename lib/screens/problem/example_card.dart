import 'package:devlearn/data/models/example.dart';
import 'package:flutter/material.dart';

class ExampleWidget extends StatelessWidget {

  final Example example;
  const ExampleWidget({super.key, required this.example});

  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: EdgeInsets.symmetric( vertical: 6, horizontal: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Tiêu đề
          Text(
            'Ví dụ ${example.order}:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Đầu vào:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: example.input,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.normal
                  )
                ),
              ]
            )
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Đầu ra:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: example.output,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.normal
                  )
                ),
              ]
            )
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Giải thích: ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: example.explanation,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.normal
                  )
                ),
              ]
            )
          ),
        ],
      ),
    );
  }
}