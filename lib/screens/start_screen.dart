import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_example_by_mladen/commons/settings.dart';
import 'package:flutter_example_by_mladen/screens/image_list_screen.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreen();
}

class _StartScreen extends State<StartScreen> {

  bool? internetStatusIsConnected;
  bool? internetTypeIsNone;
  ConnectivityResult result = ConnectivityResult.none;
  StreamSubscription? subscription;
  StreamSubscription? internetSubscription;
  void _internetCheck() async {

    internetStatusIsConnected = await InternetConnectionChecker().hasConnection;

    internetSubscription = InternetConnectionChecker().onStatusChange.listen((status) {

      setState(() {

        internetStatusIsConnected = status == InternetConnectionStatus.connected;

      });

    });

    final connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {

      internetTypeIsNone = connectivityResult == ConnectivityResult.none;

    });

    subscription = Connectivity().onConnectivityChanged.listen((result) {

      setState(() {

        internetTypeIsNone = result == ConnectivityResult.none;

      });

    });

  }

  bool? isDarkMode;
  void _themeOfDevice() {

    final window = WidgetsBinding.instance.window;

    final brightness = window.platformBrightness;

    setState(() {

      isDarkMode = brightness == Brightness.dark;

    });

    window.onPlatformBrightnessChanged = () {
      final brightnessOnChange = window.platformBrightness;

      setState(() {

        isDarkMode = brightnessOnChange == Brightness.dark;

      });

    };

  }

  Widget _constructStartScreen() {
    return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [

            SizedBox(
              height: 52,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  Text(
                      (internetStatusIsConnected == false || internetTypeIsNone == true)
                          ?
                      'You are offline'
                          :
                      'You are online',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: 16,
                          color: (isDarkMode == false) ? AppSettings.textColorLight : AppSettings.textColorDark,
                      )
                  ),

                ],
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [

                CircleAvatar(
                  radius: 64,
                  backgroundColor: AppSettings.goldColor,
                  child: Padding(
                    padding: const EdgeInsets.all(2), // Border radius
                    child: ClipOval(
                        child: Image.asset(
                          (isDarkMode == false)
                          ?
                          'assets/light_mladen225.jpg'
                          :
                          'assets/dark_mladen225.jpg',
                          height: 128,
                          width: 128,
                          fit: BoxFit.cover,
                        ),
                    ),
                  ),
                ),

                Text('Swift example by Mladen',
                    style: TextStyle(
                        fontSize: 16,
                        color: (isDarkMode == false) ? AppSettings.textColorLight : AppSettings.textColorDark,
                    )
                ),

                MaterialButton(
                  elevation: 0,
                  hoverElevation: 0,
                  focusElevation: 0,
                  highlightElevation: 0,
                  height: 48.0,
                  minWidth: MediaQuery.of(context).size.width - 0,
                  color: Colors.transparent,
                  textColor: Colors.white,
                  onPressed: () {

                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) => const ImageListScreen(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );

                  },
                  splashColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      side: const BorderSide(
                          color: AppSettings.goldColor,
                          width: 2
                      )
                  ),
                  child: const Text('PLEASE ENTER',
                      style: TextStyle(
                          fontSize: 16,
                          color: AppSettings.goldColor)
                  ),
                ),

              ].map((e) => Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: e,
              ),
              ).toList(),
            ),

            const SizedBox(height: 52,)

          ].map((e) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: e,
            ),
          ).toList(),
        )
    );
  }

  @override
  void initState() {
    super.initState();

    _themeOfDevice();

    _internetCheck();

  }

  @override
  void dispose() {

    if (null != subscription) {
      subscription!.cancel();
    }
    if (null != internetSubscription) {
      internetSubscription!.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('The System Back Button is Deactivated')));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: (isDarkMode == false) ? AppSettings.backgroundColorLight : AppSettings.backgroundColorDark,
          automaticallyImplyLeading: false,
        ),
        body: _constructStartScreen(),
        backgroundColor: (isDarkMode == false) ? AppSettings.backgroundColorLight : AppSettings.backgroundColorDark,
      ),
    );
  }

}