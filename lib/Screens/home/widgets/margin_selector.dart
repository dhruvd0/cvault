import 'package:flutter/material.dart';

class MarginSelector extends StatelessWidget {
  const MarginSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10, left: 10, top: 20, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Default margin:',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Text(
                'x.xx ',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Row(
            children: const [
              Text(
                'Currently applied to:',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              Text(
                'Global Price',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 19,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
