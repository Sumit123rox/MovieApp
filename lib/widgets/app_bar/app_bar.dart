import 'package:flutter/material.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onPress;
  final Widget? title;

  const BasicAppBar({super.key, required this.onPress, this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: title ?? Text(''),
      leading: IconButton(
          onPressed: onPress,
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.04),
                shape: BoxShape.circle),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 15,
              color: Colors.white,
            ),
          )),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
