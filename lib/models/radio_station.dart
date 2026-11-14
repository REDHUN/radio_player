class RadioStation {
  final String id;
  final String name;
  final String subtitle;
  final String location;
  final String category;
  final String streamUrl;
  final String frequencyBadge;
  final String bitrate;

  const RadioStation({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.location,
    required this.category,
    required this.streamUrl,
    required this.frequencyBadge,
    this.bitrate = '128K',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RadioStation &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

