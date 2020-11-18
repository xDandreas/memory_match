import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

bool win = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Match Game',
      theme: ThemeData(
        primaryColor: Color(0xFF232323),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
            headline2: TextStyle(color: Colors.white),
            headline4: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 55)),
      ),
      home: StartPage(),
    );
  }
}

class PlayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      startDelay: Duration(milliseconds: 1000),
      glowColor: Colors.white,
      endRadius: 160.0,
      duration: Duration(milliseconds: 2000),
      repeat: true,
      showTwoGlows: true,
      repeatPauseDuration: Duration(milliseconds: 100),
      child: MaterialButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MatchGame()),
          );
        },
        elevation: 20.0,
        shape: CircleBorder(),
        child: Container(
          width: 200.0,
          height: 200.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(160.0)),
          child: Text(
            "Play",
            style: TextStyle(
                fontSize: 75.0,
                fontWeight: FontWeight.w800,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 50.0),
              child: Text(
                "Memory Match",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://www.pinclipart.com/picdir/big/561-5611709_angle-area-green-blank-playing-cards-clipart-png.png"),
                        fit: BoxFit.fill))),
            PlayButton()
          ],
        ),
      ),
    );
  }
}

class MatchGame extends StatefulWidget {
  final int size;

  const MatchGame({Key key, this.size = 12}) : super(key: key);

  @override
  _MatchGameState createState() => _MatchGameState();
}

class _MatchGameState extends State<MatchGame> {
  List<GlobalKey<FlipCardState>> cardStateKeys = [];
  List<bool> cardFlips = [];

  //Image Pairs
  List<String> data = [
    'https://pbs.twimg.com/profile_images/1053055123193122816/IUwo6l_Q_400x400.jpg',
    'https://pbs.twimg.com/profile_images/1053055123193122816/IUwo6l_Q_400x400.jpg',
    'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/e95b2b05-3bd8-468a-bab7-2f9d5f5ec9ce/d26v4wy-109ee461-92fe-400a-bc6c-fbb03bb89ea8.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOiIsImlzcyI6InVybjphcHA6Iiwib2JqIjpbW3sicGF0aCI6IlwvZlwvZTk1YjJiMDUtM2JkOC00NjhhLWJhYjctMmY5ZDVmNWVjOWNlXC9kMjZ2NHd5LTEwOWVlNDYxLTkyZmUtNDAwYS1iYzZjLWZiYjAzYmI4OWVhOC5qcGcifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6ZmlsZS5kb3dubG9hZCJdfQ.S70ylvizQpTQFMUz5OBw6XCOHnKroU2MRGCtpd65m_k',
    'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/e95b2b05-3bd8-468a-bab7-2f9d5f5ec9ce/d26v4wy-109ee461-92fe-400a-bc6c-fbb03bb89ea8.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOiIsImlzcyI6InVybjphcHA6Iiwib2JqIjpbW3sicGF0aCI6IlwvZlwvZTk1YjJiMDUtM2JkOC00NjhhLWJhYjctMmY5ZDVmNWVjOWNlXC9kMjZ2NHd5LTEwOWVlNDYxLTkyZmUtNDAwYS1iYzZjLWZiYjAzYmI4OWVhOC5qcGcifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6ZmlsZS5kb3dubG9hZCJdfQ.S70ylvizQpTQFMUz5OBw6XCOHnKroU2MRGCtpd65m_k',
    'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/c32d77e4-b9b4-4314-9364-ca309ddbc196/d8r56nq-62029b52-e6ce-432d-a684-13111a4ec749.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOiIsImlzcyI6InVybjphcHA6Iiwib2JqIjpbW3sicGF0aCI6IlwvZlwvYzMyZDc3ZTQtYjliNC00MzE0LTkzNjQtY2EzMDlkZGJjMTk2XC9kOHI1Nm5xLTYyMDI5YjUyLWU2Y2UtNDMyZC1hNjg0LTEzMTExYTRlYzc0OS5wbmcifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6ZmlsZS5kb3dubG9hZCJdfQ.3dYIn-q3jMk9kInP82PEsW1KfcSi-b3iqy0w3Z5Xbxo',
    'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/c32d77e4-b9b4-4314-9364-ca309ddbc196/d8r56nq-62029b52-e6ce-432d-a684-13111a4ec749.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOiIsImlzcyI6InVybjphcHA6Iiwib2JqIjpbW3sicGF0aCI6IlwvZlwvYzMyZDc3ZTQtYjliNC00MzE0LTkzNjQtY2EzMDlkZGJjMTk2XC9kOHI1Nm5xLTYyMDI5YjUyLWU2Y2UtNDMyZC1hNjg0LTEzMTExYTRlYzc0OS5wbmcifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6ZmlsZS5kb3dubG9hZCJdfQ.3dYIn-q3jMk9kInP82PEsW1KfcSi-b3iqy0w3Z5Xbxo',
    'https://static.wikia.nocookie.net/fairytail/images/c/c6/Gray_in_Alvarez_Empire_arc.png/revision/latest?cb=20190519091455',
    'https://static.wikia.nocookie.net/fairytail/images/c/c6/Gray_in_Alvarez_Empire_arc.png/revision/latest?cb=20190519091455',
    'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/bf688280-039d-42ad-afe1-cac6c5c75f39/d1bd4it-186b06f3-9ec0-4588-bcb0-31a2d2853427.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOiIsImlzcyI6InVybjphcHA6Iiwib2JqIjpbW3sicGF0aCI6IlwvZlwvYmY2ODgyODAtMDM5ZC00MmFkLWFmZTEtY2FjNmM1Yzc1ZjM5XC9kMWJkNGl0LTE4NmIwNmYzLTllYzAtNDU4OC1iY2IwLTMxYTJkMjg1MzQyNy5qcGcifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6ZmlsZS5kb3dubG9hZCJdfQ.3-e0Hf-xMZmmXHd7EUgEk17OjFPxeJ8gE1pcJz2t7Zw',
    'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/bf688280-039d-42ad-afe1-cac6c5c75f39/d1bd4it-186b06f3-9ec0-4588-bcb0-31a2d2853427.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOiIsImlzcyI6InVybjphcHA6Iiwib2JqIjpbW3sicGF0aCI6IlwvZlwvYmY2ODgyODAtMDM5ZC00MmFkLWFmZTEtY2FjNmM1Yzc1ZjM5XC9kMWJkNGl0LTE4NmIwNmYzLTllYzAtNDU4OC1iY2IwLTMxYTJkMjg1MzQyNy5qcGcifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6ZmlsZS5kb3dubG9hZCJdfQ.3-e0Hf-xMZmmXHd7EUgEk17OjFPxeJ8gE1pcJz2t7Zw',
    'https://pbs.twimg.com/profile_images/378800000835531844/77b6a3c3c78279d35a338dee1f7f7f2a_400x400.png',
    'https://pbs.twimg.com/profile_images/378800000835531844/77b6a3c3c78279d35a338dee1f7f7f2a_400x400.png'
  ];

  int previousIndex = -1;
  bool flip = false;

  int time = 0;
  Timer timer;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.size; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
      cardFlips.add(true);
    }
    startTimer();
    data.shuffle();
  }

  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        if (win == false) {
          time = time + 1;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Time: $time",
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              Theme(
                data: ThemeData.dark(),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) => FlipCard(
                      key: cardStateKeys[index],
                      onFlip: () {
                        if (!flip) {
                          flip = true;
                          previousIndex = index;
                        } else {
                          flip = false;
                          if (previousIndex != index) {
                            if (data[previousIndex] != data[index]) {
                              cardStateKeys[previousIndex]
                                  .currentState
                                  .toggleCard();
                              previousIndex = index;
                            } else {
                              cardFlips[previousIndex] = false;
                              cardFlips[index] = false;

                              if (cardFlips.every((t) => t == false)) {
                                showResult();
                              }
                            }
                          }
                        }
                      },
                      direction: FlipDirection.HORIZONTAL,
                      flipOnTouch: cardFlips[index],
                      front: Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.all(4.0),
                        child: new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "https://www.freepngimg.com/thumb/logo/88500-text-awesome-question-mark-font-symbol.png")))),
                        ),
                      ),
                      back: Container(
                        margin: EdgeInsets.all(4.0),
                        child: Center(
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage("${data[index]}"),
                                      fit: BoxFit.fill))),
                        ),
                      ),
                    ),
                    itemCount: data.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showResult() {
    win = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Congratulations!"),
        content: Container(
          height: 170,
          alignment: Alignment.center,
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://img.pngio.com/score-icon-png-108819-free-icons-library-score-png-400_400.jpg"),
                            fit: BoxFit.fill))),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                  child: Text(
                    "Score: $time",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              win = false;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => StartPage(),
                ),
              );
            },
            child: Text("Go back to start"),
          ),
          FlatButton(
            onPressed: () {
              win = false;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MatchGame(
                    size: 12,
                  ),
                ),
              );
            },
            child: Text("Play again"),
          ),
        ],
      ),
    );
  }
}
