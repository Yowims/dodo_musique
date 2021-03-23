import 'package:dodo_musique/Views/Components/AccessDenied.dart';
import 'package:dodo_musique/Views/Components/WaitingIndicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Duration duration;
  Duration position;
  bool _isSearching = false;
  bool accessDenied = false;

  TextEditingController musicTitleController = new TextEditingController();
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  AudioPlayer audioPlugin = AudioPlayer();
  List<SongInfo> songs = [];
  List<SongInfo> songsAfterResearch = [];

  List<SongInfo> displayedSongs = [];

  @override
  initState() {
    super.initState();
    _loadSounds();
  }

  _loadSounds() async {
    setState(() {
      _isSearching = true;
    });
    try {
      songs = await audioQuery.getSongs();
      displayedSongs = songs;
    } on PlatformException {
      accessDenied = true;
    }

    setState(() {
      _isSearching = false;
    });
  }

  searchMusiques(String search) async {
    if (search == "") {
      setState(() {
        displayedSongs = songs;
      });
      return;
    }
    songsAfterResearch = await audioQuery.searchSongs(query: search);
    setState(() {
      displayedSongs = songsAfterResearch;
    });
  }

  @override
  void dispose() {
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
              onChanged: (value) async {
                await searchMusiques(value);
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

  Widget songsContainer(BuildContext context) {
    return Container(
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
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          audioPlugin.resume();
                        },
                        child: Text("PLAY"),
                      ),
                      TextButton(
                          onPressed: () {
                            audioPlugin.pause();
                          },
                          child: Text("PAUSE")),
                      TextButton(
                        onPressed: () {
                          audioPlugin.stop();
                          Navigator.of(context).pop();
                        },
                        child: Text("STOP"),
                      )
                    ],
                  );
                },
              );
              audioPlugin.play(displayedSongs[index].filePath);
            },
            child: Card(
              color: Theme.of(context).backgroundColor,
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
                                color: Color.fromARGB(255, 127, 127, 127)),
                          )
                        : Text(
                            "Artiste inconnu",
                            style: TextStyle(
                                color: Color.fromARGB(255, 127, 127, 127)),
                          )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // BUILD

  @override
  Widget build(BuildContext context) {
    if (_isSearching == true) {
      return Material(
        child: WaitingIndicator(),
      );
    }
    if (accessDenied == true) {
      return AccessDenied();
    } else {
      if (songs.length != 0) {
        return Material(
          child: Scaffold(
            backgroundColor: Colors.black54,
            appBar: myCustomAppBar(context),
            body: songsContainer(context),
          ),
        );
      } else {
        return Material(
          child: Scaffold(
            backgroundColor: Colors.black54,
            body: Container(
              alignment: Alignment.center,
              child: Center(
                child: Text("Aucune musique."),
              ),
            ),
          ),
        );
      }
    }
  }
}
