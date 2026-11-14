part of 'mateo_logo.dart';

/// A brand logo from the Mateo asset catalog.
enum MateoLogoData {
  /// The Cataquí logo.
  cataqui,

  /// The Gmail logo.
  gmail,

  /// The Google Messages logo.
  googleMessages,

  /// The Instagram logo.
  instagram,

  /// The Phone by Google logo.
  phoneByGoogle,

  /// The Telegram logo.
  telegram,

  /// The WhatsApp logo.
  whatsapp;

  Widget _buildSvg({required double size}) => switch (this) {
    cataqui => $Logos.cataqui(width: size, height: size),
    gmail => $Logos.gmail(width: size, height: size),
    googleMessages => $Logos.googleMessages(width: size, height: size),
    instagram => $Logos.instagram(width: size, height: size),
    phoneByGoogle => $Logos.phoneByGoogle(width: size, height: size),
    telegram => $Logos.telegram(width: size, height: size),
    whatsapp => $Logos.whatsapp(width: size, height: size),
  };
}
