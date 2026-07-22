part of 'mateo_swipe_deck.dart';

/// Controls a [MateoSwipeDeck] from parent code.
class MateoSwipeDeckController {
  _MateoSwipeDeckControllerClient? _client;

  /// Whether this controller is attached to a [MateoSwipeDeck].
  bool get hasClients => _client != null;

  /// Dismisses the current item and advances the deck.
  Future<bool> dismiss() {
    return _client?.dismissFromController() ?? Future<bool>.value(false);
  }

  /// Accepts the current item without advancing the deck.
  Future<bool> accept() {
    return _client?.acceptFromController() ?? Future<bool>.value(false);
  }

  void _attach(_MateoSwipeDeckControllerClient client) {
    assert(
      _client == null || identical(_client, client),
      'A MateoSwipeDeckController can only be attached to one MateoSwipeDeck at a time.',
    );

    _client = client;
  }

  void _detach(_MateoSwipeDeckControllerClient client) {
    if (identical(_client, client)) {
      _client = null;
    }
  }
}

abstract interface class _MateoSwipeDeckControllerClient {
  Future<bool> dismissFromController();
  Future<bool> acceptFromController();
}
