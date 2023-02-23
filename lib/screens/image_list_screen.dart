import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_example_by_mladen/commons/settings.dart';
import 'package:flutter_example_by_mladen/modules/tab_bar.dart';
import 'package:flutter_example_by_mladen/commons/mock_data.dart';
import 'package:flutter_example_by_mladen/screens/image_detail_screen.dart';
import 'package:flutter_example_by_mladen/screens/start_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ImageListScreen extends StatefulWidget {
  const ImageListScreen({Key? key}) : super(key: key);

  @override
  State<ImageListScreen> createState() => _ImageListScreen();
}

class _ImageListScreen extends State<ImageListScreen> {

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

  Widget _constructImageListScreen() {
    return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisSize: MainAxisSize.max,
          children: [

            SizedBox(
              height: 52,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  MaterialButton(
                    elevation: 0,
                    hoverElevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    color: (isDarkMode == false) ? AppSettings.backgroundColorLight : AppSettings.backgroundColorDark,
                    textColor: AppSettings.textColorLight,
                    padding: const EdgeInsets.all(0),
                    splashColor: Colors.white,
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.power_settings_new,
                            color: AppSettings.goldColor,
                            size: 24,
                          ),
                          Text(
                            ' Leave app',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppSettings.goldColor
                            ),
                          ),
                        ]),
                    onPressed: () {

                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) => const StartScreen(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );

                    },
                  ),

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

            SizedBox(
              height: MediaQuery.of(context).size.height - 52 - 56 - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              child: ListView.builder(
                  //shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: MockData.exampleList.length,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, i) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        SizedBox(
                          height: 20,
                          child: Text('Tap on image to see details',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: (isDarkMode == false) ? AppSettings.textColorLight : AppSettings.textColorDark,
                              )
                          ),
                        ),

                        GestureDetector(
                          onTap: () {

                            Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: ImageDetailScreen(
                                      screenTitle: MockData.exampleList[i]['title'] ?? '',
                                      screenText: MockData.exampleList[i]['text'] ?? '',
                                      screenImage: MockData.exampleList[i]['image'] ?? '',
                                      licenceUrl: MockData.exampleList[i]['licenceUrl'] ?? ''
                                  ),
                                  inheritTheme: true,
                                  ctx: context),
                            );

                          },
                          child: Image.asset(
                            'assets/${MockData.exampleList[i]['image'] ?? ''}',
                            height: 300,
                            width: MediaQuery.of(context).size.height - 40,
                            fit: BoxFit.cover,

                          ),
                        ),

                        Text(
                            MockData.exampleList[i]['title'] ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20,
                                color: AppSettings.goldColor)
                        ),

                      ].map((e) => Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: e,
                      ),
                      ).toList(),
                    );
                  }),
            ),



          ].map((e) => Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: e,
          ),
          ).toList(),
        ),

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
        body: _constructImageListScreen(),
        bottomNavigationBar: MyTabBar(
          itemIndex: 0,
          isDarkMode: isDarkMode ?? false,
        ),
        backgroundColor: (isDarkMode == false) ? AppSettings.backgroundColorLight : AppSettings.backgroundColorDark,
        // backgroundColor: Colors.red,
      ),
    );
  }

}