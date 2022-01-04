import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:swole_mate/auth/secrets.dart';
import 'package:swole_mate/util/exceptions.dart';

class SpotifyService {
  var redirectUri = 'swolemate://callback';
  var baseUrl = 'accounts.spotify.com';

  static final SpotifyService _spotifyService = SpotifyService._internal();

  factory SpotifyService() {
    return _spotifyService;
  }

  SpotifyService._internal();

  Future<void> connect() async {
    await SpotifySdk.connectToSpotifyRemote(
        clientId: CLIENT_ID, redirectUrl: redirectUri);
  }

  Future<void> connectToSpotifyRemote() async {
    try {
      var result = await SpotifySdk.connectToSpotifyRemote(
          clientId: CLIENT_ID, redirectUrl: redirectUri);
      // todo can connected be moved here instead of the widget?
    } on NotSpotifyAuthenticatedException catch (e) {
      rethrow;
    }
  }

  Future<String> getAuthenticationToken() async {
    try {
      var authenticationToken = await SpotifySdk.getAuthenticationToken(
          clientId: CLIENT_ID,
          redirectUrl: redirectUri,
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public,user-read-currently-playing');
      return authenticationToken;
    } on PlatformException catch (e) {
      return Future.error('$e.code: $e.message');
    } on MissingPluginException {
      return Future.error('not implemented');
    }
  }

  Future<void> play() async {
    try {
      await SpotifySdk.play(spotifyUri: 'spotify:track:0K9rIsZfdlzAoOEWyeFQYM');
    } on PlatformException catch (e) {
      print('platform exception');
    } on MissingPluginException {
      print('MissingPlugin exception');
    }
  }

  Future<void> pause() async {
    try {
      await SpotifySdk.pause();
    } on PlatformException catch (e) {
      // setStatus(e.code, message: e.message);
    } on MissingPluginException {
      // setStatus('not implemented');
    } on NoSpotifyConnection {
      rethrow;
    }
  }

  Future<void> resume() async {
    try {
      await SpotifySdk.resume();
    } on PlatformException catch (e) {
      print('platform exception');
    } on MissingPluginException {
      print('MissingPlugin exception');
    }
  }

  Future<void> skipNext() async {
    try {
      await SpotifySdk.skipNext();
    } on PlatformException catch (e) {
      print('platform exception');
    } on MissingPluginException {
      print('MissingPlugin exception');
    }
  }

  Future<void> skipPrevious() async {
    try {
      await SpotifySdk.skipPrevious();
    } on PlatformException catch (e) {
      print('platform exception');
    } on MissingPluginException {
      print('MissingPlugin exception');
    }
  }

  Future getPlayerState() async {
    try {
      return await SpotifySdk.getPlayerState();
    } on PlatformException catch (e) {
      print('platform exception');
    } on MissingPluginException {
      print('MissingPlugin exception');
    }
  }

  Widget spotifyImageWidget(ImageUri image) {
    return FutureBuilder(
        future: SpotifySdk.getImage(
          imageUri: image,
          dimension: ImageDimension.large,
        ),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.hasData) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.memory(
                snapshot.data!,
                height: 150,
                width: 150,
              ),
            );
          } else if (snapshot.hasError) {
            return SizedBox(
              width: ImageDimension.medium.value.toDouble(),
              height: ImageDimension.medium.value.toDouble(),
              child: const Center(child: Text('Error getting image')),
            );
          } else {
            return SizedBox(
              width: ImageDimension.medium.value.toDouble(),
              height: ImageDimension.medium.value.toDouble(),
              child: const Center(child: Text('Getting image...')),
            );
          }
        });
  }
}
