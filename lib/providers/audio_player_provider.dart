import 'package:flutter/material.dart';

class AudioPlaybackState extends ChangeNotifier {
  String? _currentlyPlayingId;
  bool _isPlaying = false;
  double _playbackPosition = 0.3; // Progress representation (0.0 to 1.0)
  String _activeTrackTitle = 'لم يتم اختيار تراك';

  String? get currentlyPlayingId => _currentlyPlayingId;
  bool get isPlaying => _isPlaying;
  double get playbackPosition => _playbackPosition;
  String get activeTrackTitle => _activeTrackTitle;

  void playTrack(String id, String title) {
    if (_currentlyPlayingId == id && _isPlaying) {
      pauseTrack();
    } else {
      _currentlyPlayingId = id;
      _activeTrackTitle = title;
      _isPlaying = true;
      _playbackPosition = 0.1;
      notifyListeners();
    }
  }

  void pauseTrack() {
    _isPlaying = false;
    notifyListeners();
  }

  void resumeTrack() {
    if (_currentlyPlayingId != null) {
      _isPlaying = true;
      notifyListeners();
    }
  }

  void seekTo(double val) {
    _playbackPosition = val;
    notifyListeners();
  }

  void stopTrack() {
    _isPlaying = false;
    _currentlyPlayingId = null;
    _activeTrackTitle = 'لم يتم اختيار تراك';
    _playbackPosition = 0.0;
    notifyListeners();
  }
}
