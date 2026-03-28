import 'package:flutter/foundation.dart';

class AdaptiveBlur {
  /// Defines how intense the glassmorphism blur should be.
  /// Dynamically reduced on devices with potentially lower GPU power like entry level Androids or Web.
  static double get sigma {
    if (kIsWeb) return 4.0; // Web blur is notoriously expensive
    if (defaultTargetPlatform == TargetPlatform.android) return 8.0; // Safe threshold for standard Androids
    return 12.0; // High-end devices / iOS / MacOS handle this well
  }
}
