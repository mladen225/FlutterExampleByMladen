import 'package:flutter/material.dart';
import 'package:flutter_example_by_mladen/commons/settings.dart';

class NoInternetBarrier extends StatefulWidget {
  const NoInternetBarrier({Key? key,
    required this.internetStatusIsConnected,
    required this.internetTypeIsNone,
    required this.isDarkMode
  }) : super(key: key);

  final bool internetStatusIsConnected;
  final bool internetTypeIsNone;
  final bool isDarkMode;

  @override
  State<NoInternetBarrier> createState() => _NoInternetBarrier();
}

class _NoInternetBarrier extends State<NoInternetBarrier> {

  @override
  Widget build(BuildContext context) {

    if (widget.internetStatusIsConnected == false || widget.internetTypeIsNone == true) {

      return Stack(
        alignment: AlignmentDirectional.center,
        children: [

          Container(
            color: (widget.isDarkMode == false) ? Colors.black54 : Colors.white60,
            height: MediaQuery.of(context).size.height - 52 - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
          ),

          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: (widget.isDarkMode == false) ? AppSettings.backgroundColorLight : AppSettings.backgroundColorDark,
              borderRadius: const BorderRadius.all(Radius.circular(24.0),),
              border: Border.all(
                color: AppSettings.goldColor,
                width: 2,
              ),
            ),
            width: MediaQuery.of(context).size.width - 40,
            height: MediaQuery.of(context).size.width - 40,
            child: const Text('You are off line\n\nYou need to be online in order to have functionality on this screen.\n\nThis function works only on real devices properly.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    color: AppSettings.goldColor)
            ),
            //color: Colors.white,
          )

        ],
      );

    } else {

      return const SizedBox(height: 0,);

    }

  }

}