class NotSpotifyAuthenticatedException implements Exception {
  String message;
  NotSpotifyAuthenticatedException(this.message);
}

class NoSpotifyConnection implements Exception {
  String message;
  NoSpotifyConnection(this.message);
}
