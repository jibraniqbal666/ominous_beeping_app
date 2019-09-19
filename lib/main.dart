import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shake/shake.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ominous Beeping App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Ominous Beeping App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool startBleeping = false;
  ShakeDetector detector;
  final music = <String>[
    "bleeping.mp3",
  ];
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    assetsAudioPlayer.open(
      AssetsAudio(
        asset: music[0],
        folder: "music/",
      ),
    );
    assetsAudioPlayer.finished.listen((finished) {
      if (finished && startBleeping) {
        assetsAudioPlayer.seek(Duration(seconds: 13));
        assetsAudioPlayer.play();
      }
    });
    detector = ShakeDetector.autoStart(onPhoneShake: () {
      if (!startBleeping) {
        setState(() {
          startBleeping = true;
        });
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    detector.stopListening();
    assetsAudioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (startBleeping) {
      assetsAudioPlayer.play();
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(18, 26, 43, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 0.6 * MediaQuery.of(context).size.height,
              child: GestureDetector(
                child: Stack(
                  children: <Widget>[
                    FlareActor(
                      'animation/sign.flr',
                      alignment: Alignment.topCenter,
                      fit: BoxFit.scaleDown,
                      animation: startBleeping ? 'record' : 'idle',
                      isPaused: !startBleeping,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3.0, left: 8.0),
                      child: Center(
                        child: Text(
                          "Stop",
                          style: TextStyle(fontSize: 34),
                        ),
                      ),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    startBleeping = false;
                  });
                },
              ),
            ),
            Text(
              'Ominous Beeping App',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 36,
                  color: Color.fromARGB(196, 255, 226, 255),
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Shake To Call The Mothership',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
