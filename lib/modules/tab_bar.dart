import 'package:flutter/material.dart';

import 'package:flutter_example_by_mladen/commons/settings.dart';

import 'package:flutter_example_by_mladen/screens/image_list_screen.dart';
import 'package:flutter_example_by_mladen/screens/connect_screen.dart';

class MyTabBar extends StatefulWidget {
  const MyTabBar({Key? key,
    required this.itemIndex,
    required this.isDarkMode
  }) : super(key: key);

  final int itemIndex;
  final bool isDarkMode;

  @override
  State<MyTabBar> createState() => _MyTabBar();
}

class _MyTabBar extends State<MyTabBar> {

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (currentIndex) {
        setState(() {

          switch (currentIndex) {
            case 0:

              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const ImageListScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );

              break;
            case 1:

              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const ConnectScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );

              break;
            default:
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => const ImageListScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
              break;
          }
        });
      },
      currentIndex: widget.itemIndex,
      backgroundColor: (widget.isDarkMode == false) ? AppSettings.backgroundColorLight : AppSettings.backgroundColorDark,
      unselectedItemColor: Colors.grey,
      selectedItemColor: AppSettings.goldColor,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'List',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.phone),
          label: 'Contact',
        ),

      ],

    );
  }
}