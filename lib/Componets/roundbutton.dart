import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final Color bgcolor;
  final bool loading;
  final VoidCallback ontap;
  const Button(
      {super.key,
      required this.title,
      this.bgcolor = Colors.black,
      this.loading = false,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: InkWell(
        onTap: ontap,
        child: Container(
          height: 50,
          width: 250,
          decoration: BoxDecoration(
            color: bgcolor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
              child: loading
                  ? const CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.black,
                    )
                  : Text(
                      title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )),
        ),
      ),
    );
  }
}
