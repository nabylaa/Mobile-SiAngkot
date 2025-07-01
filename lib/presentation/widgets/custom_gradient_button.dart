import 'package:flutter/material.dart';
import 'package:si_angkot/gen/colors.gen.dart';

// Gradient Button Widget
class CustomGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(
          50), // Tambahkan di sini juga agar efek ripple mengikuti bentuk rounded
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(
            colors: [
              MyColors.primaryColor,
              MyColors.secondaryColor,
            ],
          ),
        ), // Pastikan withGradient mempertahankan borderRadius
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// use this widget like this
// GradientButton(text: "Login", onPressed: () => print("Button Pressed")),
