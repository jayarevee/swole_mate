import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:swole_mate/constants.dart';
import 'package:swole_mate/screens/spotify_screen.dart';
import 'package:swole_mate/util/spotify_service.dart';
import 'package:swole_mate/widgets/resusable_card.dart';
import 'package:swole_mate/widgets/round_icon_button.dart';

class SpotifyWidget extends StatefulWidget {
  const SpotifyWidget({Key? key}) : super(key: key);

  @override
  _SpotifyWidgetState createState() => _SpotifyWidgetState();
}

class _SpotifyWidgetState extends State<SpotifyWidget> {
  bool isPlaying = false;

  late ImageUri? currentTrackImageUri;
  final SpotifyService spotifyService = SpotifyService();
  IconData isPlayingIcon = Icons.play_arrow;
  bool _connected = false;
  late Widget spotifyWidget = spotifySettings(); // widget that is displayed

  void togglePlaying() {
    if (isPlaying) {
      spotifyService.pause();
    } else {
      spotifyService.resume();
    }
    setState(() {
      isPlaying = !isPlaying;
      isPlayingIcon = isPlaying ? Icons.pause : Icons.play_arrow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectionStatus>(
      stream: SpotifySdk.subscribeConnectionStatus(),
      builder: (context, snapshot) {
        _connected = false;
        var data = snapshot.data;
        if (data != null) {
          _connected = data.connected;
        }
        return _connected ? buildPlayer() : spotifySettings();
      },
    );
  }

  Widget buildPlayer() {
    return StreamBuilder<PlayerState>(
        stream: SpotifySdk.subscribePlayerState(),
        builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
          var track = snapshot.data?.track;
          currentTrackImageUri = track?.imageUri;
          var playerState = snapshot.data;
          if (playerState == null || track == null) {
            return spotifySettings();
          }

          return ReusableCard(
            color: kWidgetColor,
            cardChild: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: spotifyService.spotifyImageWidget(track.imageUri),
              ),
              Text(
                '${track.name} by ${track.artist.name}',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                RoundIconButton(
                  onPress: () {
                    spotifyService.skipPrevious();
                  },
                  icon: FontAwesomeIcons.arrowLeft,
                ),
                RoundIconButton(
                  onPress: () {
                    togglePlaying();
                  },
                  icon: isPlayingIcon,
                ),
                RoundIconButton(
                  onPress: () {
                    spotifyService.skipNext();
                  },
                  icon: FontAwesomeIcons.arrowRight,
                ),
              ]),
              Align(
                alignment: Alignment.center,
                child: MaterialButton(
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => SpotifyScreen(),
                          ));
                    }),
              )
            ]),
            function: () {},
          );
        });
  }

  Widget spotifySettings() {
    return Center(
      child: Container(
          child: Align(
        alignment: Alignment.center,
        child: MaterialButton(
            child: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () async {
              _connected = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SpotifyScreen(),
                  ));
              setState(() {
                spotifyWidget = _connected ? buildPlayer() : spotifySettings();
              });
            }),
      )),
    );
  }
}
