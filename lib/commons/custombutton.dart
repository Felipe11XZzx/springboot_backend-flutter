import 'package:flutter/material.dart';

class CustomEButton extends StatelessWidget {
  final String text;
  final Function myFunction;
  final IconData? icon;
  const CustomEButton ({
    super.key,
    required this.text,
    required this.myFunction,
    this.icon
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          textStyle: const TextStyle(fontSize: 15),
        ),
        onPressed: () {
          myFunction();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ... [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(width: 15),
            ],
            Text(text),
          ],
        )
      ),
    );
  }
}

class CustomEButtonAdmin extends StatelessWidget {
  final String text;
  final Function myFunction;
  final IconData? icon;
  const CustomEButtonAdmin ({
    super.key,
    required this.text,
    required this.myFunction,
    this.icon
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          textStyle: const TextStyle(fontSize: 15),
        ),
        onPressed: () {
          myFunction();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ... [
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                icon,
                color: Colors.white,
                ),
              ),
              const SizedBox(width: 15),
            ],
            Text(text),
          ],
        )
      ),
    );
  }
}