import 'package:flutter/material.dart';
import 'package:flutter_example_by_mladen/commons/settings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_example_by_mladen/modules/no_internet_barrier.dart';

class ImageDetailScreen extends StatefulWidget {
  const ImageDetailScreen({Key? key,
    required this.screenTitle,
    required this.screenText,
    required this.screenImage,
    required this.licenceUrl,
  }) : super(key: key);

  final String screenTitle;
  final String screenText;
  final String screenImage;
  final String licenceUrl;

  @override
  State<ImageDetailScreen> createState() => _ImageDetailScreen();
}

class _ImageDetailScreen extends State<ImageDetailScreen> {

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

  Future<void> _launchUrl(String url) async {

    final Uri web = Uri.parse(url);

    if (!await launchUrl(web)) {
      throw 'Could not launch $web';
    }
  }

  Widget _constructImageDetailScreen() {
    return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            SizedBox(
              height: 52,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  IconButton(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      onPressed: () {

                        Navigator.pop(context);

                      },
                      iconSize: 32,
                      icon: const Icon(Icons.chevron_left, color: AppSettings.goldColor, size: 32,)
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

                ].map((e) => Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                  child: e,
                ),
                ).toList(),
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height - 52 - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [

                  Scrollbar(
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                        const BoxConstraints(minWidth: 100, minHeight: 1000),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[

                            SizedBox(
                              height: 20,
                              child: Text(
                                  widget.screenTitle,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: (isDarkMode == false) ? AppSettings.textColorLight : AppSettings.textColorDark,
                                  )
                              ),
                            ),

                            Image.asset(
                              'assets/${widget.screenImage}',
                              height: 300,
                              width: MediaQuery.of(context).size.height - 40,
                              fit: BoxFit.cover,

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

                                _launchUrl(widget.licenceUrl);

                              },
                              splashColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  side: const BorderSide(
                                      color: AppSettings.goldColor,
                                      width: 2
                                  )
                              ),
                              child: const Text('Go to Licence page',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppSettings.goldColor)
                              ),
                            ),

                            SizedBox(
                              width: MediaQuery.of(context).size.height - 40,
                              child: Text(
                                  widget.screenText,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: (isDarkMode == false) ? AppSettings.textColorLight : AppSettings.textColorDark,
                                  )
                              ),
                            ),

                          ].map((e) => Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: e,
                          ),
                          ).toList(),
                        ),
                      ),
                    ),
                  ),

                  NoInternetBarrier(
                    internetStatusIsConnected: internetStatusIsConnected ?? true,
                    internetTypeIsNone: internetTypeIsNone ?? false,
                    isDarkMode: isDarkMode ?? false,
                  ),

                ],
              ),
            ),

          ],
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
        body: _constructImageDetailScreen(),
        backgroundColor: (isDarkMode == false) ? AppSettings.backgroundColorLight : AppSettings.backgroundColorDark,
      ),
    );
  }

}