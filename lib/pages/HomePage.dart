import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flute_music_player/flute_music_player.dart';

import '../main.dart';

enum PlayerState { stopped, playing, paused }

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
  Duration duration;
  Duration position;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  MusicFinder audioPlayer;
  List<Song> songs;
  List<Song> displayedSongs = new List<Song>();
  bool _isSearching = false;

  TextEditingController musicTitleController = new TextEditingController();

  PlayerState playerState = PlayerState.stopped;

  @override
  initState() {
    super.initState();
    audioPlayer = new MusicFinder();
    fetchSongs();
  }

  searchMusiques(String search) {
    while (displayedSongs.isNotEmpty) {
      displayedSongs.removeLast();
    }
    if (search.isNotEmpty) {
      songs.forEach((element) {
        if (element.title.toLowerCase().startsWith(search.toLowerCase())) {
          setState(() {
            displayedSongs.add(element);
          });
        }
      });
    } else {
      fetchSongs();
    }
  }

  Future _playLocal(songPath) async {
    final result = await audioPlayer.play(songPath, isLocal: true);
    if (result == 1) setState(() => playerState = PlayerState.playing);
  }

  Future pause() async {
    final result = await audioPlayer.pause();
    if (result == 1) setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    final result = await audioPlayer.stop();
    if (result == 1)
      setState(() {
        playerState = PlayerState.stopped;
        position = new Duration();
      });
  }

  Future fetchSongs() async {
    setState(() {
      _isSearching = true;
    });
    try {
      songs = await MusicFinder.allSongs().whenComplete(() {
        setState(() {
          _isSearching = false;
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    audioPlayer = null;
    super.dispose();
  }

  AppBar myCustomAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Dodo Musique'),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) {
                searchMusiques(value);
              },
              controller: musicTitleController,
              decoration: InputDecoration(
                  labelText: "Rechercher une musique",
                  hintText: "Rechercher une musique...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)))),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isSearching == true) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      if (displayedSongs.length != 0) {
        return Material(
          child: Scaffold(
              backgroundColor: Colors.black54,
              appBar: myCustomAppBar(context),
              body: Container(
                child: ListView.builder(
                    itemCount: displayedSongs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text("${displayedSongs[index].title}"),
                                content: Text(''),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      _playLocal(displayedSongs[index].uri);
                                    },
                                    child: Text("PLAY"),
                                  ),
                                  FlatButton(
                                      onPressed: () {
                                        pause();
                                      },
                                      child: Text("PAUSE")),
                                  FlatButton(
                                    onPressed: () {
                                      stop();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("STOP"),
                                  )
                                ],
                              );
                            },
                          );
                          _playLocal(displayedSongs[index].uri);
                        },
                        child: Card(
                          color: matBlack,
                          elevation: 1,
                          child: SizedBox(
                            height: 50,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  displayedSongs[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white),
                                ),
                                displayedSongs[index].artist != "<unknown>"
                                    ? Text(
                                        "${displayedSongs[index].artist}",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 127, 127, 127)),
                                      )
                                    : Text(
                                        "Artiste inconnu",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 127, 127, 127)),
                                      )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              )),
        );
      } else {
        return Material(
          child: Scaffold(
              backgroundColor: Colors.black54,
              appBar: myCustomAppBar(context),
              body: Container(
                child: ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: Text("${songs[index].title}"),
                                content: Text(''),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      _playLocal(songs[index].uri);
                                    },
                                    child: Text("PLAY"),
                                  ),
                                  FlatButton(
                                      onPressed: () {
                                        pause();
                                      },
                                      child: Text("PAUSE")),
                                  FlatButton(
                                    onPressed: () {
                                      stop();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("STOP"),
                                  )
                                ],
                              );
                            },
                          );
                          _playLocal(songs[index].uri);
                        },
                        child: Card(
                          color: matBlack,
                          elevation: 1,
                          child: SizedBox(
                            height: 50,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  songs[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white),
                                ),
                                songs[index].artist != "<unknown>"
                                    ? Text(
                                        "${songs[index].artist}",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 127, 127, 127)),
                                      )
                                    : Text(
                                        "Artiste inconnu",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 127, 127, 127)),
                                      )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              )),
        );
      }
    }
  }
}
