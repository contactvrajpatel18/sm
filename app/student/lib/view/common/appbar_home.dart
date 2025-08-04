import 'package:flutter/material.dart';

class AppbarHome extends StatelessWidget implements PreferredSizeWidget {
  const AppbarHome({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60); 

  @override
  Widget build(BuildContext context) {
    return Container(

//! App Bar Decoration
      
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 5)),
        ],
      ),

//! logo / Menu Icon

      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Builder(
              builder:
                  (context) => IconButton(
                    icon: Icon(Icons.menu, color: Colors.black),
                    onPressed: () {
                      Scaffold.of(
                        context,
                      ).openDrawer();
                    },
                  ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Image.asset("assets/from.png", width: 90, height: 60),
            ),
          ],
        ),
      ),
    );
  }
}

