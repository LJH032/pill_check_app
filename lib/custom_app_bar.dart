import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ),
      ),
      backgroundColor: const Color(0xFFE9E9E9),
      centerTitle: true,
      elevation: 0,
      leading: onBackPressed != null
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: onBackPressed,
      )
          : null, // onBackPressed가 null이면 leading을 표시하지 않음
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
