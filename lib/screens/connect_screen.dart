import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_example_by_mladen/modules/tab_bar.dart';
import 'package:flutter_example_by_mladen/modules/no_internet_barrier.dart';
import 'package:flutter_example_by_mladen/commons/settings.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_example_by_mladen/screens/start_screen.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({Key? key}) : super(key: key);

  @override
  State<ConnectScreen> createState() => _ConnectScreen();
}

class _ConnectScreen extends State<ConnectScreen> {

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

  static const CameraPosition _myHomeLocation = CameraPosition(
    target: LatLng(43.848869, 18.390827),
    zoom: 17,
  );

  Marker myHomeMarker = const Marker(
    markerId: MarkerId('home'),
    position: LatLng(43.848869, 18.390827),
    infoWindow: InfoWindow(title: 'My Home', snippet: 'B. Mutevelica 31')
  );

  Future<void> _callPhone(String number) async {

    final call = Uri.parse(number);
    if (await canLaunchUrl(call)) {
      launchUrl(call);
    } else {
      throw 'Could not launch $call';
    }
  }

  Future<void> _sendMail(String address) async {

    final email = Uri(
      scheme: 'mailto',
      path: address,
      query: 'subject=Hello&body=Test',
    );
    if (await canLaunchUrl(email)) {
      launchUrl(email);
    } else {
      throw 'Could not launch $email';
    }
  }

  Widget _constructConnectScreen() {
    return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
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

                ].map((e) => Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: e,
                ),
                ).toList(),
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height - 52 - 56 - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [

                  Scrollbar(
                      child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints:
                            const BoxConstraints(minWidth: 100, minHeight: 502),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Container(
                                  height: 350,
                                  child: GoogleMap(
                                    myLocationButtonEnabled: false,
                                    mapType: MapType.normal,
                                    initialCameraPosition: _myHomeLocation,
                                    markers: {myHomeMarker},
                                  ),
                                ),

                                SizedBox(
                                  height: 24,
                                  child: MaterialButton(
                                    elevation: 0,
                                    hoverElevation: 0,
                                    focusElevation: 0,
                                    highlightElevation: 0,
                                    height: 24.0,
                                    color: (isDarkMode == false) ? AppSettings.backgroundColorLight : AppSettings.backgroundColorDark,
                                    textColor: AppSettings.textColorLight,
                                    padding: const EdgeInsets.all(0),
                                    splashColor: Colors.white,
                                    child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.phone,
                                            color: AppSettings.goldColor,
                                            size: 24,
                                          ),
                                          Text(
                                            ' +387574998',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: AppSettings.goldColor
                                            ),
                                          ),
                                        ]),
                                    onPressed: () {

                                      _callPhone('tel:+38762574998');

                                    },
                                  ),
                                ),

                                SizedBox(
                                  height: 24,
                                  child: MaterialButton(
                                    elevation: 0,
                                    hoverElevation: 0,
                                    focusElevation: 0,
                                    highlightElevation: 0,
                                    height: 24.0,
                                    color: (isDarkMode == false) ? AppSettings.backgroundColorLight : AppSettings.backgroundColorDark,
                                    textColor: AppSettings.textColorLight,
                                    padding: const EdgeInsets.all(0),
                                    splashColor: Colors.white,
                                    child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.mail,
                                            color: AppSettings.goldColor,
                                            size: 24,
                                          ),
                                          Text(
                                            ' mladen225@gmail.com',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: AppSettings.goldColor
                                            ),
                                          ),
                                        ]),
                                    onPressed: () {

                                      _sendMail('mladen225@gmail.com');

                                    },
                                  ),
                                ),

                                const SizedBox(
                                  height: 24,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_on,
                                          color: AppSettings.goldColor,
                                          size: 24,
                                        ),
                                        Text(
                                          ' B. Mutevelica 31',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppSettings.goldColor
                                          ),
                                        ),
                                      ]),
                                )

                              ].map((e) => Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                child: e,
                              ),
                              ).toList(),
                            ),
                          )
                      )
                  ),

                  NoInternetBarrier(
                    internetStatusIsConnected: internetStatusIsConnected ?? true,
                    internetTypeIsNone: internetTypeIsNone ?? false,
                    isDarkMode: isDarkMode ?? false,
                  ),

                ],
              ),
            ),

          ]
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
        body: _constructConnectScreen(),
        bottomNavigationBar: MyTabBar(
          itemIndex: 1,
          isDarkMode: isDarkMode ?? false,
        ),
        backgroundColor: (isDarkMode == false) ? AppSettings.backgroundColorLight : AppSettings.backgroundColorDark,
      ),
    );
  }

}