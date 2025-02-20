extension StringCasingExtension on String {
  String get toCapitalized {
    return length > 0
        ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}'
        : '';
  }

  String get toTitleCase {
    return replaceAll(RegExp(' +'), ' ')
        .split(' ')
        .map((str) => str.toCapitalized)
        .join(' ');
  }
}
