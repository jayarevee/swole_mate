import 'package:flutter/material.dart';
import 'package:swole_mate/util/spotify_service.dart';

class SpotifyScreen extends StatelessWidget {
  final SpotifyService spotifyService = SpotifyService();
  late bool _isConnected = false;
  showAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = MaterialButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context, _isConnected);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Spotify Authentication"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spotify settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _isConnected);
          },
        ),
      ),
      body: Row(
        children: [
          MaterialButton(
            onPressed: () async {
              try {
                await spotifyService.connect();
                _isConnected = true;
                showAlertDialog(context, "Successfully connected to Spotify");
                Navigator.pop(context);
              } catch (e) {
                showAlertDialog(context, "Error connecting with Spotify");
                //todo add logging
              }
              Navigator.pop(context, _isConnected);
            },
            child: Text('Connect'),
            color: Colors.white,
          ),
          MaterialButton(
            onPressed: () async {
              //spotifyService.login();
              try {
                var token = await spotifyService.getAuthenticationToken();
                showAlertDialog(
                    context, "Successfully authenticated with Spotify");
              } catch (e) {
                showAlertDialog(context, "Error authenticating with Spotify");
                //todo add logging

              }
            },
            child: Text('Authenticate'),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
