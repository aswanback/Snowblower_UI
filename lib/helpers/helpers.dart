import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final void Function(String)? onChanged;
  final String label;
  final bool obscure;
  final Color color;

  const CustomTextField(
      {super.key,
      required this.label,
      required this.onChanged,
      this.obscure = false,
      required this.color});
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      onChanged: onChanged,
      cursorColor: color,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: color), // TextStyle(color: color),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: color)),
        labelText: label,
        labelStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: color), //TextStyle(color: color),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final double height;

  const CustomTextButton(
      {super.key,
      required this.text,
      this.onPressed,
      required this.backgroundColor,
      required this.textColor,
      this.height = 40,
      this.width = 220});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(height)),
        )),
        backgroundColor: MaterialStatePropertyAll<Color>(backgroundColor),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
